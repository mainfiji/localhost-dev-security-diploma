# Сегментация сети офиса Санкт‑Петербург

## Цель

Выполнить логическое разделение сети офиса СПБ на сегменты в соответствии с требованиями безопасности.

---

## Новая схема сети

### Сегменты

| Сегмент | Подсеть | Назначение |
|---------|---------|------------|
| Uplink | 172.52.135.0/24 | Сеть провайдера |
| Users | 10.97.23.0/24 | Пользовательские рабочие станции |
| DMZ | 10.97.24.0/24 | Публичные сервисы (прокси, VPN‑шлюз) |
| Servers | 10.97.25.0/24 | Внутренние серверы (файловый) |
| Admin | 10.97.26.0/24 | Администрирование (бастион) |

### Распределение хостов

| Хост | Сегмент | IP‑адрес |
|------|---------|----------|
| branch_isp | Uplink | 172.52.135.254 |
| branch_fw | Uplink | 172.52.135.100 |
| ws_spb_000845, ws_spb_000833, ws_spb_000721, ws_spb_000777 | Users | 10.97.23.* |
| srv_branch_dns | Users | 10.97.23.44 |
| srv_branch_polarproxy | DMZ | 10.97.24.50 |
| srv_branch_wg_gate | DMZ | 10.97.24.200 |
| srv_branch_fs | Servers | 10.97.25.33 |
| srv_branch_bastion | Admin | 10.97.26.66 |

---

## Таблица сетевых потоков (branch)

| Источник | Назначение | Протокол/порт | Назначение |
|----------|------------|---------------|------------|
| Все внутренние хосты | srv_ldap (центр) | LDAP 389/TCP | Аутентификация |
| Users | proxy (DMZ) | TCP 3128 | Web‑доступ через прокси |
| proxy | Интернет | TCP 80/443 | Доступ к вебу |
| Users | srv_dns | UDP 53 | DNS |
| Users | srv_ansible (центр) | TCP 22 | Управление |
| Admin | Все хосты | TCP 22 | Администрирование |
| Servers | srv_dns | UDP 53 | DNS |
| Servers | srv_ldap | TCP 389 | LDAP |
| Все | fw_branch | ICMP | Диагностика |

---

## Конфигурация docker‑compose‑branch.yml (фрагменты)

```yaml
# DMZ
srv_branch_polarproxy:
  environment:
    GATEWAY_IP: ${SUBNET_BRANCH_DMZ}.${IP_BRANCH_FW}
  networks:
    branch_dmz_net:
      ipv4_address: ${SUBNET_BRANCH_DMZ}.${IP_SRV_BRANCH_POLARPROXY}

srv_branch_wg_gate:
  environment:
    GATEWAY_IP: ${SUBNET_BRANCH_DMZ}.${IP_BRANCH_FW}
  networks:
    branch_dmz_net:
      ipv4_address: ${SUBNET_BRANCH_DMZ}.${IP_SRV_BRANCH_WG_GATE}

# Servers
srv_branch_fs:
  environment:
    GATEWAY_IP: ${SUBNET_BRANCH_SERVERS}.${IP_BRANCH_FW}
  networks:
    branch_servers_net:
      ipv4_address: ${SUBNET_BRANCH_SERVERS}.${IP_SRV_BRANCH_FS}

# Admin
srv_branch_bastion:
  environment:
    GATEWAY_IP: ${SUBNET_BRANCH_ADMIN}.${IP_BRANCH_FW}
  networks:
    branch_admin_net:
      ipv4_address: ${SUBNET_BRANCH_ADMIN}.${IP_SRV_BRANCH_BASTION}
```
Конфигурация nftables (branch_fw)
```bash
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        iif lo accept
        ct state established,related accept
        ip protocol icmp accept
        ip saddr 10.97.26.0/24 tcp dport 22 accept   # SSH из Admin
    }

    chain forward {
        type filter hook forward priority 0; policy drop;
        ct state established,related accept

        # Users → DNS
        ip saddr 10.97.23.0/24 ip daddr 10.97.23.44 udp dport 53 accept
        ip saddr 10.97.23.0/24 ip daddr 10.97.23.44 tcp dport 53 accept

        # Users → Proxy (DMZ)
        ip saddr 10.97.23.0/24 ip daddr 10.97.24.50 tcp dport 3128 accept

        # Proxy → Интернет
        ip saddr 10.97.24.50 oifname "brnch-uplink" tcp dport {80,443} accept

        # Users → File Server
        ip saddr 10.97.23.0/24 ip daddr 10.97.25.33 tcp dport 445 accept

        # Admin → All (SSH)
        ip saddr 10.97.26.0/24 tcp dport 22 accept

        # Users → LDAP (центр)
        ip saddr 10.97.23.0/24 ip daddr 192.168.201.199 tcp dport 389 accept

        # Users → NTP (центр)
        ip saddr 10.97.23.0/24 udp dport 123 accept

        # Users → Mail (центр)
        ip saddr 10.97.23.0/24 tcp dport {25,143,587} accept

        log prefix "FW-BLOCK: "
        drop
    }

    chain output {
        type filter hook output priority 0; policy accept;
    }
}

table ip nat {
    chain postrouting {
        type nat hook postrouting priority 100;
        oifname "brnch-uplink" masquerade
    }
}
```
Проверка доступности
С рабочей станции пользователя (ws_spb_*) доступны: DNS, прокси, файловый сервер, LDAP, NTP, почта.

С бастиона (admin) доступ по SSH ко всем хостам.

Из интернета доступны только опубликованные сервисы (через DNAT).

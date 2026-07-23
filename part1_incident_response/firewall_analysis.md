# Задача 2. Анализ правил МСЭ центрального офиса

## Описание проблемы

Руководитель может подключиться по SSH к любому хосту со своего персонального компьютера. Согласно политике, SSH-доступ разрешён только из сегмента управления.

## Исследование

### Текущие правила nftables на srv_fw

```bash
nft list ruleset
Выявленные недостатки
Правило	Суть правила	Описание недостатка	Исправленное правило
ip saddr @internal_nets ip daddr @internal_nets tcp dport 22 accept	Нет ограничения по источнику	Lateral movement	ip saddr @admin_net ip daddr @internal_nets tcp dport 22 accept
ip saddr @internal_nets tcp dport 22 drop
ip saddr @internal_nets oifname "eth_uplink" accept	Нет контроля исходящего трафика	Обход прокси, утечка данных	ip saddr @users_net tcp dport {80,443} accept
ip saddr @users_net oifname "eth_uplink" drop
ip saddr @users_net ip daddr @users_net udp dport 3389 accept	Избыточный доступ	Распространение атак	ip saddr @admin_net ip daddr @users_net tcp dport 3389 accept

```
Решение
Применены исправленные правила:

```bash
# SSH только из сегмента управления
nft add rule inet filter forward ip saddr 192.168.205.0/24 ip daddr 192.168.201.0/24 tcp dport 22 accept
nft add rule inet filter forward ip saddr 192.168.202.0/24 ip daddr 192.168.201.0/24 tcp dport 22 drop

# RDP только из сегмента управления
nft add rule inet filter forward ip saddr 192.168.205.0/24 ip daddr 192.168.201.0/24 tcp dport 3389 accept
nft add rule inet filter forward ip saddr 192.168.202.0/24 ip daddr 192.168.201.0/24 tcp dport 3389 drop
```
Результат
SSH-доступ разрешён только из сегмента управления (192.168.205.0/24)

RDP-доступ разрешён только из сегмента управления

Все правила приведены в соответствие с картой сетевых потоков

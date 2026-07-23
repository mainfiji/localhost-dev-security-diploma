# Задача 8. Настройка доступа и логирования на файловом сервере СПБ

## Конфигурация smb.conf

```ini
[global]
workgroup = WORKGROUP
security = user
map to guest = Never
usershare allow guests = no

passdb backend = ldapsam:ldap://srv_branch_dns
ldap suffix = dc=local,dc=host
ldap admin dn = cn=admin,dc=local,dc=host
ldap user suffix = ou=users
ldap group suffix = ou=groups
ldap ssl = no

log file = /var/log/samba/log.%m
max log size = 50

# Настройка аудита
vfs objects = full_audit
full_audit:prefix = %u|%I|%S
full_audit:success = connect disconnect open opendir read write rename unlink mkdir rmdir
full_audit:failure = none
full_audit:facility = LOCAL7
full_audit:priority = NOTICE

[share_all]
path = /srv/samba/share_all
browseable = yes
read only = no
guest ok = no
valid users = @spb_all

[it]
path = /srv/samba/it
browseable = yes
read only = no
guest ok = no
valid users = @spb_it

[hr]
path = /srv/samba/hr
browseable = yes
read only = no
guest ok = no
valid users = @spb_hr
Настройка логирования
ini
vfs objects = full_audit
full_audit:prefix = %u|%I|%S
full_audit:success = connect disconnect open opendir read write rename unlink mkdir rmdir
full_audit:failure = none
full_audit:facility = LOCAL7
full_audit:priority = NOTICE
Логи записываются в:

/var/log/syslog

/var/log/samba/log.*

```
Результат
Гостевой доступ отключён (guest ok = no, map to guest = Never)

Настроена аутентификация через LDAP

Созданы ресурсные группы для отделов (спб_all, спб_it, спб_hr)

Включено логирование всех операций с файлами

Срок хранения логов — 52 недели (ротация weekly)

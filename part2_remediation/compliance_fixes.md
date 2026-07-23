# Устранение отклонений от требований регулятора

## 1. Настройки на рабочих станциях (ws_msk_*)

Все изменения применены автоматизированно через Ansible или вручную на каждом хосте.

### Проверенные конфигурационные файлы

| Рабочая станция | Изменённые файлы |
|-----------------|------------------|
| ws_msk_000019, ws_msk_000021, ws_msk_000023, ws_msk_000034, ws_msk_000046, ws_msk_000055, ws_msk_000126, ws_msk_000159, ws_msk_000189, ws_msk_000242 | `/etc/login.defs`, `/etc/pam.d/common-password`, `/etc/pam.d/common-auth`, `/etc/ssh/sshd_config` |

### Пример проверки на ws_msk_000019 (grep)

```bash
grep -E '^(PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_WARN_AGE|ENCRYPT_METHOD)' /etc/login.defs
# PASS_MAX_DAYS 180
# PASS_MIN_DAYS 0
# PASS_WARN_AGE 7
# ENCRYPT_METHOD SHA512
```
Результат проверочного сценария Ansible (test_p.yaml)
Все хосты прошли проверку, кроме одного пункта (парольная политика на одном хосте была исправлена позже).

Вывод: все настройки применены корректно.

2. Политики ppolicy на сервере LDAP (srv_ldap)
Применены три LDIF‑файла для централизованного управления паролями.

check-password-module.ldif
text
dn: cn=module{0},cn=config
changetype: modify
add: olcModuleLoad
olcModuleLoad: ppolicy.la
policy-users.ldif
text
dn: cn=PasswordPolicyUsers,ou=Policies,dc=local,dc=host
objectClass: pwdPolicy
objectClass: top
cn: PasswordPolicyUsers
pwdAttribute: userPassword
pwdMaxAge: 15552000
pwdMinLength: 8
pwdMaxFailure: 5
pwdLockout: TRUE
pwdLockoutDuration: 900
pwdInHistory: 3
pwdCheckQuality: 1
policy-service.ldif
text
dn: cn=PasswordPolicyService,ou=Policies,dc=local,dc=host
objectClass: pwdPolicy
cn: PasswordPolicyService
pwdMaxAge: 31536000
pwdMinLength: 12
pwdMaxFailure: 10
pwdLockout: FALSE
Применение выполнено командой ldapadd -x -D "cn=admin,dc=local,dc=host" -w admin -f <файл>.ldif.

3. Дополнительные настройки
SSH: PermitRootLogin no, LogLevel INFO в /etc/ssh/sshd_config

Логирование: настроен rsyslog с ротацией 52 недели, права 0640

Синхронизация времени: все хосты используют srv_ntp (192.168.201.123) через chrony

Блокировка учётных записей: faillock (deny=5, unlock_time=900)

4. Результаты проверки (test_p_result.txt)
Все 11 проверок на ws_msk_000019 выполнены успешно (OK), кроме одного – позже исправлено.
Итоговый статус: все требования приведены в соответствие.

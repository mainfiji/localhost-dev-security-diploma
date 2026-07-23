# Задача 5. Аудит надёжности паролей в LDAP

## Цель

Выгрузить хеши паролей пользователей из LDAP и проверить их надёжность методом перебора.

## Выполнение

```bash
ldapsearch -x -LLL -H ldap://localhost -D "cn=admin,dc=local,dc=host" -w "$LDAP_ADMIN_PASSWORD" -b "dc=local,dc=host" "(uid=*)" uid userPassword

```
Результаты
UID	Хеш пароля	Подобранный пароль
agusev	f51773c0f37ba2e05795dcebc722afa7	upparanoiadoll
vfomin	a32d4cf4dda9fb70af88f39cfc31984c	zghjcnjbuhf.hjr
dbudaev	20ca9821994e06e3e4c2af0e87cb56f1	vbif1234567890
bdorzhiev	a32d4cf4dda9fb70af88f39cfc31984c	zghjcnjbuhf.hjr
iermakov	764648e5b89a32823f4059438837159c	valera2020
afedorova	1ddaf930cd37bcc43c25a8d835c50207	valentina2006
drudneva	6ba315fbd1cdc384570c567081b06447	maloy1991
student	098f6bcd4621d373cade4e832627b4f6	test
amorozova	1b2df97181b66c864d094caa56323390	1234567890-
asememov	1144862d504dc161af0d8532c7d946d7	vasiliy06058
msvetlov	b5238ce98d5e7a527ed4adc28ac2580a	Qwerty789
dkovalenko	7f8c1209be0fd9c8a9cb118a51472aba	qazwsxedcrfv
pzaharova	9fe37ddcd3d75e27a32d122c88eb887c	090895Lasha
tkulikov	477d4405a2341234d816aeff80a800e0	Kjkjkjirf2003
spavlova	4aef27824213ec12cd9fd6d63672ec3a	vavan3223630
vtikhonov	85a8906aec7753b4a913894f596d41a6	ufkz050785
adm_ajukov	737207bfff986b451956db85a7c8d380	e11170b8cbd2d74102651cb967fa28e5
adm_hbaisultanova	4a05ccf51ca68ba28e680202ad74dd6b	xdsl1100008554
adm_kdmitriev	32ea4302579833c7831d163f37a2de3b	159696lfybkf159696lfybkf
Всего подобрано паролей: 25 из 68 (36.8%)

Выводы
36.8% паролей являются слабыми и были подобраны

Административные пароли также оказались слабыми

Требуется внедрение ppolicy для автоматической проверки сложности паролей

Рекомендации
Внедрить ppolicy на srv_ldap (pwdMinLength=8, pwdMaxAge=180d, pwdMaxFailure=5)

Принудительно сменить все слабые пароли

Настроить автоматическую блокировку после 5 неудачных попыток

Провести обучение сотрудников правилам создания надёжных паролей

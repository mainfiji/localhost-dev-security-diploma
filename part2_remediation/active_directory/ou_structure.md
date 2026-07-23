# Структура организационных единиц (OU)

## Дерево OU
int.local.host
├── Disabled Accounts # заблокированные / уволенные сотрудники
├── Groups
│ ├── ADMIN # административные группы
│ │ ├── Domain Admins
│ │ └── Enterprise Admins
│ ├── INFRA # инфраструктурные группы
│ │ ├── SG-ADM-T1-SRV-LINUX-ADMINS
│ │ └── SG-ADM-T1-NET-ADMINS
│ ├── ORG # организационные (ролевые) группы
│ │ ├── SG-ORG-ALL-Users
│ │ ├── SG-ORG-IT-Users
│ │ └── SG-ORG-OPS-Users
│ └── RES # ресурсные группы
│ ├── SG-RES-SHARE-hq_dep_it-RW
│ └── SG-RES-SHARE-hq_dep_legal-RO
├── Users
│ ├── m.romanov
│ ├── a.ivanov
│ ├── adm_* (административные учётки)
│ └── … (остальные пользователи)
└── Service Accounts
└── svc_admin_ib

text

## Описание групп

| Группа | Тип | Назначение |
|--------|-----|------------|
| `Domain Admins` | Административная | Полный доступ к домену |
| `Enterprise Admins` | Административная | Управление всей лесной структурой |
| `SG-ADM-T1-SRV-LINUX-ADMINS` | Инфраструктурная | Администраторы Linux-серверов (T1) |
| `SG-ADM-T1-NET-ADMINS` | Инфраструктурная | Сетевые администраторы (T1) |
| `SG-ORG-ALL-Users` | Организационная | Все пользователи домена |
| `SG-ORG-IT-Users` | Организационная | Сотрудники IT-отдела |
| `SG-ORG-OPS-Users` | Организационная | Сотрудники отдела эксплуатации |
| `SG-RES-SHARE-hq_dep_it-RW` | Ресурсная | Доступ на запись к IT-ресурсам |
| `SG-RES-SHARE-hq_dep_legal-RO` | Ресурсная | Доступ на чтение к юридическим документам |

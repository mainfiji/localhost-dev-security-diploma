``markdown
# Внедрение антивирусной защиты (ClamAV)

## Ansible‑плейбук `clamav.yml`


Скрипт clamav_full_scan.sh
bash
#!/bin/bash
LOGFILE="/var/log/clamav/clamav_scan_$(date +%Y%m%d).log"
echo "Starting full system scan at $(date)" >> $LOGFILE
clamscan -r / --exclude-dir=/sys --exclude-dir=/proc --exclude-dir=/dev --exclude-dir=/run --exclude-dir=/mnt --exclude-dir=/media --exclude-dir=/var/log/clamav -l $LOGFILE
echo "Scan finished at $(date)" >> $LOGFILE
Проверка с EICAR‑файлом
bash
echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' > /tmp/eicar.com
clamscan /tmp/eicar.com
# /tmp/eicar.com: Eicar-Test-Signature FOUND
Результаты проверочного сценария Ansible (test_a_result.txt)
Хост	Статус
ws_msk_000019, ws_msk_000021, … , ws_msk_000242	OK
srv_fs	OK
Все хосты успешно прошли проверку – ClamAV установлен, базы обновлены, cron‑задание добавлено.

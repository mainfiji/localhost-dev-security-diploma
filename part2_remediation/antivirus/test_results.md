# Результаты тестирования антивирусной защиты

## Методология

Для проверки работоспособности ClamAV использовался тестовый файл EICAR.  
Файл был размещён на каждом хосте, после чего выполнялось сканирование.

---

## Тест на EICAR

### Команда

```bash
echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' > /tmp/eicar.com
clamscan /tmp/eicar.com
```
Результат
text
/tmp/eicar.com: Eicar-Test-Signature FOUND
Статус:  Вирус обнаружен.

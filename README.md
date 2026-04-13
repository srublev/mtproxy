# mtproto-proxy

## Сборка образа
```
docker build -t <image_name>:<tag> .
```

## Запуск
1. Загрузка конфигов Telegram
```
curl -s https://core.telegram.org/getProxySecret -o proxy-secret
curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf
```
2. Генерация секрета
```
openssl rand -hex 16

# секрет нужно прописать в docker-compose.yml

```

3. Включение режима Fake TLS
```
Указать в docker-compose.yml переменную
FAKE_TLS_DOMAIN: <какой-то популярный ресурс, поддерживающий https>
```

4. Старт контейнера
```
docker compose up -d
```

5. Проверить что в логах нет ошибок
```
docker compose logs
```
В логах также выводятся
SECRET - секрет для работы без Fake TLS
CLIENT_SECRET - секрет для работы через Fake TLS (должен начинаться с `ee`)


## Использование в клиенте
ссылка для подключения proxy без Fake TLS
```
tg://proxy?server=<IP_ADRESS>&port=<PORT>&secret=<SECRET>
```

ссылка для подключения proxy c Fake TLS
```
tg://proxy?server=<IP_ADRESS>&port=<PORT>&secret=<CLIENT_SECRET>
```




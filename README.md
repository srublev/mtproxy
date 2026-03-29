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

3. Старт контейнера
```
docker compose up -d
```

## Использование в клиенте
ссылка для подключения proxy
```
tg://proxy?server=<IP_ADRESS>&port=<PORT>&secret=<SECRET>
```

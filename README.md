# Weather_api

Приложения для отображения температуры по городам.

## Запуск

Для запуска необходимо скачать репозиторий  и установить все необходимые гемы.
В корне приложения открыть терминал и выполнить команду.

```
bundle install
```
Далее запустить миграции:

```
rails db:migrate
```

Наконец можно запустить сервер:

```
rails server
```

## Для корректной работы необходимо подготовить данные для отображения

Загружаем перечень городов.Приложение возьмет данные из файла, в корне:
(знаю, что так не хорошо делать,но чтобы не отправлять файл отдельно)

```
curl http://localhost:3000/locations/update_city_name
```

Берем данные о Location_key(необходим для выгрузки погоды с Accuweather API)

```
curl http://localhost:3000/locations/update_location_key
```

Заполняем базу данных информацией о погоде за последние 24 часа.
```
curl http://localhost:3000/locations/:id/weather/update_forecast
```

Для этого необходимо указать "id:" требуемого города.
По умолчанию:

1. Мариуполь
2. Москва
3. Нижний Новгород
4. Таганрог
5. Ростов
6. Орел
7. Донецк

##  Для отображения используется несколько эндпоинтов

- Текущая температура по Цельсию (берется напрямую из Accuweather API)

```
curl http://localhost:3000/locations/:id/weather/current
```

- Температура за последние 24 часа (берется из БД как и последующие. Для обновления необходимо обновлять базу, 
пример выше "update_forecast") 

```
curl http://localhost:3000/locations/:id/weather/historical
```
- Максимальная температура за послдение 24 часа

```
curl http://localhost:3000/locations/:id/weather/historical/max
```
- Минимальная температура за последние 24 часа

```
curl http://localhost:3000/locations/:id/weather/historical/min
```

- Средняя температура за последние 24 часа

```
curl http://localhost:3000/locations/:id/weather/historical/avg
```

- Ближайшая температура на указанное время. Необходимо внести данные в переменную "timestamp" в формате Unix

```
curl http://localhost:3000/locations/:id/weather/by_time?timestamp=
```

 - Статус Бэкенда

```
curl http://localhost:3000/health
```

## Дополнительная информация

Для корректной работы нужен API key, который можно получить перейдя по [ссылке]( https://developer.accuweather.com/) и зарегестрироваься. Ключ необходимо поместить  в 
"credentials.yml.enc". 



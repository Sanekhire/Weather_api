# Weather_api

## API для отображения температуры по городам.

## Запуск

Для запуска необходимо скачать репозиторий и установить все необходимые гемы.
В корне приложения открыть терминал и выполнить команду.

```
bundle install
```

Далее запустить миграции:

```
rails db:migrate
```

Запускаем проверку с помощью тестов:

```
bundle exec rspec
```

Теперь необходимо подготовить данные (Заполняем таблицы):

```
rake tables_data:first_fill
```

Наконец можно запустить сервер:

```
rails server
```

---

## Для отображения используется несколько эндпоинтов

\*\*Примечание: вместо `:city_name` указываем город, по которому нужно просмотреть информацию. Перечень доступных городов отображаеттся на главной странице.

- Текущая температура по Цельсию

```
http://localhost:3000/locations/:city_name/weather/current
```

- Температура за последние 24 часа

```
http://localhost:3000/locations/:city_name/weather/historical
```

- Максимальная температура за послдение 24 часа

```
http://localhost:3000/locations/:city_name/weather/historical/max
```

- Минимальная температура за последние 24 часа

```
http://localhost:3000/locations/:city_name/weather/historical/min
```

- Средняя температура за последние 24 часа

```
http://localhost:3000/locations/:city_name/weather/historical/avg
```

- Ближайшая температура на указанное время. Необходимо внести данные в формате Unix после `input=`

```
http://localhost:3000/locations/:city_name/weather/by_time?input=
```

- Статус Бэкенда

```
http://localhost:3000/health
```

## Дополнительная информация

**Для работы необходим APIKEY, который можно взять [тут](https://developer.accuweather.com/) и поместить его в
**`credentials.yml.enc` `weather_api_key:`

**В программе введена валидация на количество городов, не более 10, так как запросы по API в Accuweather ограничены в 50
**запросов по бесплатной подписке.

Города, по умолчанию:

Mariupol
Moscow
Nizhniy Novgorod
Taganrog
Rostov-Na-Donu
Orel
Donetsk

\*\*Для включения ежечасного обновления данных по температуре необходимо выполнить команду:

```
whenever --update-crontab
```

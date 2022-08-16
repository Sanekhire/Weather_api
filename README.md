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

Теперь необходимо подготовить данные. Запускааем консоль rails:

```
rails console
```

1. Определяем перечень городов, по которым необходимо смотреть температуру.

   - Для автоматичееской загрузки всего перечня городов(3594), необходимо указать атрибут source как 'site'.

   ```
   CityName.load_data(source)
   ```

   - Для загрузки перечня по умолчанию не указыать атрибут и будут загружены следующие города:
     ('Mariupol', 'Moscow', 'Nizhniy Novgorod', 'Taganrog', 'Rostov-Na-Donu', 'Orel', 'Donetsk')

   ```
   CityName.load_data
   ```

2. Добавляем ключи по городам. Они необходимы для загрузки данных погоды с AccuweatherAPI

```
LocationKey.load_to_city
```

3. Загружаем данные температуры:

```
WeatherData.load_data(city)
```

\*Где `city` строка с наименованием города.

Выходим из консоли Rails.

```
quit
```

Наконец можно запустить сервер:

```
rails server
```

---

## Для отображения используется несколько эндпоинтов

\*\*Примечание: вместо `:city_name` указываем город, по которому нужно просмотреть информацию

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

- Ближайшая температура на указанное время. Необходимо внести данные в переменную "timestamp" в формате Unix

```
http://localhost:3000/locations/:city_name/weather/by_time?timestamp=
```

- Статус Бэкенда

```
http://localhost:3000/health
```

## Дополнительная информация

**В программе введена валидация на количество городов не более 10, так как запросы по API в Accuweather ограничены в 50
**запросов.

Города, по умолчанию:

Mariupol
Moscow
Nizhniy Novgorod
Taganrog
Rostov-Na-Donu
Orel
Donetsk

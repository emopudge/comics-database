# Comics Database 📚

Платформа для чтения, публикации и обсуждения комиксов.  
Проект разработан в рамках лабораторных работ по проектированию баз данных и демонстрирует навыки работы с реляционными и документными СУБД.

> 💡 **Важно**: В работе не рассматриваются вопросы хостинга, масштабируемости или монетизации. Акцент сделан на моделировании данных, пользовательских сценариях и реализации SQL/MongoDB-логики.

---

## 🛠️ Технологический стек

- **Реляционная БД**: PostgreSQL + pgAdmin 4  
- **NoSQL**: MongoDB Atlas + Compass  
- **Язык запросов**: SQL, MongoDB Aggregation Framework  
- **Python**: генерация данных (`psycopg2`, `Faker`, `BeautifulSoup`)  
- **Моделирование**: ERD (нотация Чена), DFD

---

## ▶️ Как запустить SQL-часть проекта

1. **Создайте базу данных** в PostgreSQL (например, `comics_db`).
2. **Выполните скрипты в следующем порядке**:
   ```sql
   -- 1. Создание структуры
   sql/create-tables.sql

   -- 2. Заполнение данными
   sql/sample-data.sql

   -- 3. Дополнительные операции (по желанию)
   sql/update-delete.sql
   sql/transaction.sql
   sql/trigger.sql
   sql/cursor.sql

## 📊 SQL-запросы
- [`sql/queries-comics.sql`](sql/queries-comics.sql) — 17 запросов для базы комиксов  

## ⚙️ Продвинутые механизмы PostgreSQL

- [`sql/triggers.sql`](sql/triggers.sql) — триггер, запрещающий комментарии забаненным пользователям  
- [`sql/transaction.sql`](sql/transaction.sql) — атомарная транзакция покупки комикса с проверкой баланса  
- [`sql/cursor.sql`](sql/cursor.sql) — курсор для автоматического расчёта популярности комиксов
  
## 🐍 Генерация данных с помощью Python (Бонус)

Скрипты в папке `python/` автоматически заполняют базу данными, включая реальные названия комиксов с [spidermedia.ru](https://spidermedia.ru/mustread).

### Как запустить:
1. Создайте `python/config.py` по образцу `config.example.py`
2. Установите зависимости:  
   ```bash
   pip install -r python/requirements.txt
3. Запустите:
   ```bash
   python python/database.py

## 📦 MongoDB: миграция и запросы

- [`mongodb/migration-guide.md`](mongodb/migration-guide.md) — пошаговая инструкция по переносу данных из PostgreSQL  
- [`mongodb/queries-mongodb.js`](mongodb/queries-mongodb.js) — 17 ключевых запросов на MongoDB (агрегации, соединения, представления)

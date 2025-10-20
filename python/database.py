# database.py
from psycopg2 import connect
from config import DATABASE_CONFIG
from faker import Faker
from random import randint, choice
from parsing import info

fake = Faker()

def connect_postgres():
    try:
        conn = connect(**DATABASE_CONFIG)
        print("✅ Подключение к PostgreSQL успешно")
        return conn
    except Exception as e:
        print(f"❌ Ошибка подключения: {e}")
        return None

def generate_id(cursor, table):
    while True:
        id_val = fake.random_number(digits=6, fix_len=True)
        cursor.execute(f'SELECT "{table} ID" FROM "{table}" WHERE "{table} ID" = %s;', (id_val,))
        if not cursor.fetchone():
            return id_val

if __name__ == "__main__":
    conn = connect_postgres()
    if not conn:
        exit(1)
    cursor = conn.cursor()

    # Убедимся, что данных достаточно
    min_len = min(len(info[0]), len(info[2]))
    for i in range(min(20, min_len)):
        # Reader
        reader_id = generate_id(cursor, 'Reader')
        nickname = fake.user_name()
        login = fake.email()
        password = fake.password()
        cursor.execute(
            'INSERT INTO public."Reader" ("Nickname", "Login", "Password", "User ID") VALUES (%s, %s, %s, %s);',
            (nickname, login, password, reader_id)
        )

        # Team
        team_id = generate_id(cursor, 'Team')
        team_name = fake.company() + ' Comics'
        cursor.execute(
            'INSERT INTO public."Team" ("Team ID", "Name") VALUES (%s, %s);',
            (team_id, team_name)
        )

        # Content-maker
        content_maker_id = generate_id(cursor, 'Content-maker')
        cm_nickname = fake.user_name()
        cm_login = fake.email()
        cm_password = fake.password()
        cursor.execute(
            'INSERT INTO public."Content-maker" ("Nickname", "Login", "Password", "Content-maker ID") VALUES (%s, %s, %s, %s);',
            (cm_nickname, cm_login, cm_password, content_maker_id)
        )

        # Comics
        comics_name = info[0][i]
        comics_id = generate_id(cursor, 'Comics')
        comics_descr = info[2][i]
        release_date = fake.date()
        cursor.execute(
            'INSERT INTO public."Comics" ("Name", "Comics ID", "Description", "Team ID", "Release date") VALUES (%s, %s, %s, %s, %s);',
            (comics_name, comics_id, comics_descr, team_id, release_date)
        )

        # Subscription
        price = randint(50, 500)
        payment_date = fake.date()
        payment_id = generate_id(cursor, 'Subscription')
        cursor.execute(
            'INSERT INTO public."Subscription" ("Price", "Payment date", "User ID", "Comics ID", "Payment ID") VALUES (%s, %s, %s, %s, %s);',
            (price, payment_date, reader_id, comics_id, payment_id)
        )

        # Comment
        comment_id = generate_id(cursor, "Comment")
        text = fake.sentence()
        comment_date = fake.date()
        cursor.execute(
            'INSERT INTO public."Comment" ("Date", "Text", "User ID", "Comment ID", "Comics ID") VALUES (%s, %s, %s, %s, %s);',
            (comment_date, text, reader_id, comment_id, comics_id)
        )

        # Chapter
        chapter_id = randint(1, 100)
        chapter_name = fake.word()
        cursor.execute(
            'INSERT INTO public."Chapter" ("Chapter ID", "Comics ID", "Name") VALUES (%s, %s, %s);',
            (chapter_id, comics_id, chapter_name)
        )

        # Collection
        collection_id = generate_id(cursor, "Collection")
        collection_name = fake.word()
        cursor.execute(
            'INSERT INTO public."Collection" ("Collection ID", "Name", "User ID") VALUES (%s, %s, %s);',
            (collection_id, collection_name, reader_id)
        )

        # Collection Positions
        collection_note = fake.sentence()
        cursor.execute(
            'INSERT INTO public."Collection Positions" ("Collection ID", "Comics ID", "Note") VALUES (%s, %s, %s);',
            (collection_id, comics_id, collection_note)
        )

        # Team roles
        role_name = choice(['writer', 'painter', 'assistant', 'translator', 'editor'])
        cursor.execute(
            'INSERT INTO public."Team roles" ("Team ID", "Content-maker ID", "Role name") VALUES (%s, %s, %s);',
            (team_id, content_maker_id, role_name)
        )

    conn.commit()
    cursor.close()
    conn.close()
    print("✅ Данные успешно добавлены!")

-- =============================================
-- SQL-запросы: Comics Database (ЛР3)
-- =============================================

-- №1. Модификация таблицы: добавление рейтинга
ALTER TABLE "Comics"
ADD COLUMN rating INTEGER;

-- №2. Выборка всех данных из таблицы Chapter
SELECT * FROM public."Chapter";

-- №3. Уникальные роли в командах
SELECT DISTINCT "Role name"
FROM "Team roles";

-- №4 + №6. Фильтрация по описанию и дате выпуска
SELECT "Name", "Comics ID", "Release date", "Team ID", "Description"
FROM public."Comics"
WHERE "Description" NOT LIKE '%комикс%'
  AND "Release date" BETWEEN '1999-01-01' AND '2016-12-31';

-- №5. Роли из заданного набора
SELECT * FROM "Team roles"
WHERE "Role name" IN ('painter', 'translator');

-- №7. Комментарии с непустым текстом
SELECT * FROM "Comment"
WHERE "Text" IS NOT NULL;

-- №8. Сортировка по цене и году оплаты
SELECT "Price", "Payment date", "Reader ID", "Comics ID", "Payment ID"
FROM public."Subscription"
ORDER BY "Price" DESC, EXTRACT(YEAR FROM "Payment date") DESC;

-- №9. Внутреннее соединение: коллекции и читатели
SELECT c."Name" AS "Collection Name", r."Nickname"
FROM "Collection" c
INNER JOIN "Reader" r ON c."User ID" = r."User ID";

-- №10. Правое соединение: все читатели, даже без подписок
SELECT s."Price", s."Comics ID", r."Nickname"
FROM public."Subscription" s
RIGHT JOIN public."Reader" r ON s."User ID" = r."User ID";

-- №11. Левое соединение: все комиксы, даже без подписок
SELECT cm."Name" AS comics_title, s."Payment date"
FROM "Comics" cm
LEFT JOIN "Subscription" s ON cm."Comics ID" = s."Comics ID";

-- №12. Полное внешнее соединение: команды и контент-мейкеры
SELECT tm."Name" AS team_name, cntm."Nickname" AS maker_nickname
FROM "Team roles" tr
FULL OUTER JOIN "Team" tm ON tr."Team ID" = tm."Team ID"
FULL OUTER JOIN "Content-maker" cntm ON cntm."Content-maker ID" = tr."Content-maker ID";

-- №13. Объединение: японские комиксы + общая таблица
CREATE TABLE "Japanese comics" (
    "Comics ID" INTEGER PRIMARY KEY,
    "Name" TEXT NOT NULL,
    "Release date" DATE NOT NULL,
    "Team ID" INTEGER NOT NULL,
    "Description" TEXT,
    rating INTEGER
);

INSERT INTO "Japanese comics" ("Comics ID", "Name", "Description", "Team ID", "Release date", rating)
VALUES (123456, 'Bungo stray dogs', 'The Armed Detective Agency investigates...', 100001, '2006-11-12', 9);

SELECT * FROM "Japanese comics"
UNION
SELECT "Comics ID", "Name", "Release date", "Team ID", "Description", rating
FROM "Comics";

-- №14. Группировка: количество комментариев по пользователю и комиксу
SELECT 
    COUNT(cmt."Text") AS "Comment counts",
    rid."Nickname",
    cms."Name"
FROM "Comment" cmt
INNER JOIN "Reader" rid ON rid."User ID" = cmt."User ID"
INNER JOIN "Comics" cms ON cms."Comics ID" = cmt."Comics ID"
GROUP BY cms."Name", rid."Nickname";

-- №15. Вложенный подзапрос: пользователи, комментировавшие после 2025
SELECT DISTINCT r."Nickname"
FROM "Reader" r
WHERE r."User ID" IN (
    SELECT c."User ID"
    FROM "Comment" c
    INNER JOIN "Comics" cm ON c."Comics ID" = cm."Comics ID"
    WHERE c."Date" > '2025-01-01'
);

-- №16. Модифицируемое представление: художники
CREATE VIEW public."Painter_ID" AS
SELECT "Team ID", "Content-maker ID", "Role name"
FROM "Team roles"
WHERE "Role name" = 'painter';

-- №17. Немодифицируемое представление: подсчёт глав
CREATE VIEW comic_chapter_counter AS
SELECT cm."Name" AS name, COUNT(ch."Chapter ID") AS chapter_count
FROM "Comics" cm
LEFT JOIN "Chapter" ch ON cm."Comics ID" = ch."Comics ID"
GROUP BY cm."Name";

-- Проверка представления
SELECT * FROM comic_chapter_counter;

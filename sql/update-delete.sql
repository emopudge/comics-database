-- update-delete.sql: Примеры модификации и удаления данных

-- Изменение данных
UPDATE public."Team"
SET "Name" = 'Balabala'
WHERE "Name" = 'Bilibili';

UPDATE public."Collection"
SET "Name" = 'Самое любимое'
WHERE "Name" = 'Любимое';

UPDATE public."Collection"
SET "Collection ID" = 300006
WHERE "Collection ID" = 300005;

UPDATE public."Collection Positions"
SET "Collection ID" = 300004, "Note" = 'Прочитано, но стоит перечитать'
WHERE "Collection ID" = 300006;

UPDATE public."Subscription"
SET "Price" = 120
WHERE "Price" >= 150;

-- Удаление данных
DELETE FROM public."Team roles"
WHERE "Role name" = 'Художник' AND "Content-maker ID" = 700001;

DELETE FROM public."Comment"
WHERE "Comment ID" = 6000004 AND "Comics ID" = 400001;

DELETE FROM public."Subscription"
WHERE "User ID" = 200003;

DELETE FROM public."Comics"
WHERE "Release date" > '2016-12-31';

-- ⚠️ Осторожно: следующая команда удалит ВСЕ комиксы!
-- DELETE FROM public."Comics";

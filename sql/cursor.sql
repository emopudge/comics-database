-- cursor.sql: Курсор для автоматического определения популярности комиксов

-- Добавляем столбец "Popularity", если его нет
ALTER TABLE public."Comics"
ADD COLUMN IF NOT EXISTS "Popularity" TEXT;

-- Расчёт популярности на основе количества подписок
DO $$
DECLARE
    average_subscription SMALLINT;
    comics_id INT;
    subscr_count SMALLINT;
    comic_cursor CURSOR FOR
        SELECT "Comics ID", COUNT("Payment ID") AS subscr_counter
        FROM public."Subscription"
        GROUP BY "Comics ID";
    curr_data RECORD;
BEGIN
    -- Среднее количество подписок на комикс
    SELECT ROUND(COUNT("Payment ID")::NUMERIC / COUNT(DISTINCT "Comics ID"))
    INTO average_subscription
    FROM public."Subscription";

    -- Проходим по каждому комиксу
    OPEN comic_cursor;
    LOOP
        FETCH comic_cursor INTO curr_data;
        EXIT WHEN NOT FOUND;

        comics_id := curr_data."Comics ID";
        subscr_count := curr_data.subscr_counter;

        -- Присваиваем уровень популярности
        IF subscr_count > average_subscription THEN
            UPDATE public."Comics" SET "Popularity" = 'Высокая' WHERE "Comics ID" = comics_id;
        ELSIF subscr_count = average_subscription THEN
            UPDATE public."Comics" SET "Popularity" = 'Средняя' WHERE "Comics ID" = comics_id;
        ELSE
            UPDATE public."Comics" SET "Popularity" = 'Низкая' WHERE "Comics ID" = comics_id;
        END IF;
    END LOOP;
    CLOSE comic_cursor;
END $$;

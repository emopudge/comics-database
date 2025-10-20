-- triggers.sql: Триггер для запрета комментариев забаненным пользователям

-- Добавим поле "Статус" в таблицу Reader (если ещё не добавлено)
ALTER TABLE public."Reader"
ADD COLUMN IF NOT EXISTS "Статус" TEXT DEFAULT 'активен';

-- Функция проверки статуса пользователя перед добавлением комментария
CREATE OR REPLACE FUNCTION check_comment_permission()
RETURNS TRIGGER AS $$
DECLARE
    commentator_status TEXT;
BEGIN
    SELECT "Статус" INTO commentator_status
    FROM public."Reader"
    WHERE "Reader ID" = NEW."Reader ID";

    IF commentator_status = 'бан' THEN
        RAISE EXCEPTION 'Читатель не имеет права оставлять комментарии';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер: срабатывает перед INSERT в таблицу Comment
CREATE TRIGGER check_comment_permission
BEFORE INSERT ON public."Comment"
FOR EACH ROW
EXECUTE FUNCTION check_comment_permission();

-- Пример использования:
-- UPDATE public."Reader" SET "Статус" = 'бан' WHERE "Reader ID" = 200001;
-- INSERT INTO public."Comment" (...) VALUES (...);  -- вызовет ошибку

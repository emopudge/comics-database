-- transaction.sql: Транзакция покупки комикса с проверкой баланса

-- Добавляем необходимые поля (если ещё не добавлены)
ALTER TABLE "Reader" ADD COLUMN IF NOT EXISTS balance INTEGER NOT NULL DEFAULT 0;
ALTER TABLE "Comics" ADD COLUMN IF NOT EXISTS price SMALLINT NOT NULL DEFAULT 0;
ALTER TABLE "Team" ADD COLUMN IF NOT EXISTS balance INTEGER NOT NULL DEFAULT 0;

-- Устанавливаем цену для конкретного комикса
UPDATE "Comics"
SET price = 1001
WHERE "Comics ID" = 175636;

-- Пополняем баланс читателя (для теста успешной покупки)
UPDATE "Reader"
SET balance = 1001
WHERE "Reader ID" = 118405;

-- Основная транзакция: покупка подписки
DO $$
DECLARE
    bal INTEGER;
    pr INTEGER;
BEGIN
    -- Блокируем строку читателя для предотвращения гонки
    SELECT balance INTO bal
    FROM "Reader"
    WHERE "Reader ID" = 118405
    FOR UPDATE;

    SELECT price INTO pr
    FROM "Comics"
    WHERE "Comics ID" = 175636;

    IF bal < pr THEN
        RAISE EXCEPTION 'Недостаточно средств для покупки подписки:(';
    ELSE
        -- Списываем деньги с читателя
        UPDATE "Reader"
        SET balance = balance - pr
        WHERE "Reader ID" = 118405;

        -- Начисляем деньги команде
        UPDATE "Team"
        SET balance = balance + pr
        WHERE "Team ID" = (
            SELECT "Team ID"
            FROM "Comics"
            WHERE "Comics ID" = 175636
        );

        -- Создаём запись о подписке
        INSERT INTO "Subscription" ("Reader ID", "Comics ID", "Price", "Payment date", "Payment ID")
        VALUES (118405, 175636, pr, CURRENT_DATE, 111114);
    END IF;
END $$;

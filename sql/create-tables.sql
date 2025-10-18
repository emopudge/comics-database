-- Структура базы данных Comics Database (PostgreSQL)

-- Таблица пользователей (читателей)
CREATE TABLE IF NOT EXISTS public."Reader" (
    "Nickname" text COLLATE pg_catalog."default" NOT NULL,
    "Login" text COLLATE pg_catalog."default" NOT NULL,
    "Password" text COLLATE pg_catalog."default" NOT NULL,
    "User ID" integer NOT NULL,
    CONSTRAINT reader_pkey PRIMARY KEY ("User ID")
);

-- Таблица контент-мейкеров (художники, переводчики)
CREATE TABLE IF NOT EXISTS public."Content-maker" (
    "Nickname" text COLLATE pg_catalog."default" NOT NULL,
    "Login" text COLLATE pg_catalog."default" NOT NULL,
    "Password" text COLLATE pg_catalog."default" NOT NULL,
    "Content-maker ID" integer NOT NULL,
    CONSTRAINT "Content-maker_pkey" PRIMARY KEY ("Content-maker ID")
);

-- Таблица команд
CREATE TABLE IF NOT EXISTS public."Team" (
    "Team ID" integer NOT NULL,
    "Name" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Team_pkey" PRIMARY KEY ("Team ID")
);

-- Таблица ролей в командах
CREATE TABLE IF NOT EXISTS public."Team roles" (
    "Team ID" integer NOT NULL,
    "Content-maker ID" integer NOT NULL,
    "Role name" text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Team roles_pkey" PRIMARY KEY ("Team ID", "Content-maker ID"),
    CONSTRAINT "Team roles_Content-maker ID_fkey" FOREIGN KEY ("Content-maker ID")
        REFERENCES public."Content-maker" ("Content-maker ID") MATCH SIMPLE
        ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT "Team roles_Team ID_fkey" FOREIGN KEY ("Team ID")
        REFERENCES public."Team" ("Team ID") MATCH SIMPLE
        ON UPDATE RESTRICT ON DELETE CASCADE
);

-- Таблица комиксов
CREATE TABLE IF NOT EXISTS public."Comics" (
    "Name" text COLLATE pg_catalog."default" NOT NULL,
    "Comics ID" integer NOT NULL,
    "Release date" date NOT NULL,
    "Team ID" integer NOT NULL,
    "Description" text COLLATE pg_catalog."default",
    CONSTRAINT "Comics_pkey" PRIMARY KEY ("Comics ID"),
    CONSTRAINT "Comics_Team_ID_fkey" FOREIGN KEY ("Team ID")
        REFERENCES public."Team" ("Team ID") MATCH SIMPLE
        ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- Таблица глав комиксов
CREATE TABLE IF NOT EXISTS public."Chapter" (
    "Chapter ID" smallint NOT NULL,
    "Comics ID" integer NOT NULL,
    "Name" text COLLATE pg_catalog."default",
    CONSTRAINT "Chapter_pkey" PRIMARY KEY ("Chapter ID", "Comics ID"),
    CONSTRAINT "Chapter_Comics_ID_fkey" FOREIGN KEY ("Comics ID")
        REFERENCES public."Comics" ("Comics ID") MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Таблица подписок
CREATE TABLE IF NOT EXISTS public."Subscription" (
    "Price" smallint,
    "Payment date" date NOT NULL,
    "User ID" integer NOT NULL,
    "Comics ID" integer NOT NULL,
    "Payment ID" integer NOT NULL,
    CONSTRAINT "Subscription_pkey" PRIMARY KEY ("Payment ID"),
    CONSTRAINT "Subscription_Comics_ID_fkey" FOREIGN KEY ("Comics ID")
        REFERENCES public."Comics" ("Comics ID") MATCH SIMPLE
        ON UPDATE RESTRICT ON DELETE NO ACTION,
    CONSTRAINT "Subscription_User_ID_fkey" FOREIGN KEY ("User ID")
        REFERENCES public."Reader" ("User ID") MATCH SIMPLE
        ON UPDATE RESTRICT ON DELETE CASCADE
);

-- Таблица комментариев
CREATE TABLE IF NOT EXISTS public."Comment" (
    "Date" date NOT NULL,
    "Text" text COLLATE pg_catalog."default" NOT NULL,
    "User ID" integer NOT NULL,
    "Comment ID" integer NOT NULL,
    "Comics ID" integer NOT NULL,
    CONSTRAINT "Comment_pkey" PRIMARY KEY ("Comment ID"),
    CONSTRAINT "Comment_Comics_ID_fkey" FOREIGN KEY ("Comics ID")
        REFERENCES public."Comics" ("Comics ID") MATCH SIMPLE
        ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT "Comment_User_ID_fkey" FOREIGN KEY ("User ID")
        REFERENCES public."Reader" ("User ID") MATCH SIMPLE
        ON UPDATE RESTRICT ON DELETE CASCADE
);

-- Таблица коллекций
CREATE TABLE IF NOT EXISTS public."Collection" (
    "Collection ID" integer NOT NULL,
    "Name" text COLLATE pg_catalog."default" NOT NULL,
    "User ID" integer NOT NULL,
    CONSTRAINT "Collection_pkey" PRIMARY KEY ("Collection ID"),
    CONSTRAINT "Collection_User_ID_fkey" FOREIGN KEY ("User ID")
        REFERENCES public."Reader" ("User ID") MATCH SIMPLE
        ON UPDATE RESTRICT ON DELETE CASCADE
);

-- Таблица позиций в коллекциях
CREATE TABLE IF NOT EXISTS public."Collection Positions" (
    "Collection ID" integer NOT NULL,
    "Comics ID" integer NOT NULL,
    "Note" text COLLATE pg_catalog."default",
    CONSTRAINT "Collection Positions_pkey" PRIMARY KEY ("Collection ID", "Comics ID"),
    CONSTRAINT "Collection Positions_Collection ID_fkey" FOREIGN KEY ("Collection ID")
        REFERENCES public."Collection" ("Collection ID") MATCH SIMPLE
        ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT "Collection Positions_Comics ID_fkey" FOREIGN KEY ("Comics ID")
        REFERENCES public."Comics" ("Comics ID") MATCH SIMPLE
        ON UPDATE RESTRICT ON DELETE CASCADE
);

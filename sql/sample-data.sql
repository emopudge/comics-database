-- Примеры данных для всех таблиц

-- Сначала независимые сущности
INSERT INTO public."Team"("Team ID", "Name")
VALUES 
  (100001, 'Dreamteam house'),
  (100002, 'Musasi Miyamoto'),
  (100003, 'Bilibili');

INSERT INTO public."Content-maker"("Nickname", "Login", "Password", "Content-maker ID")
VALUES 
  ('Beon Deok', 'cat_enjoyer@gmail.com', 'beon378', 700001),
  ('Demantur', 'demon@yandex.ru', 'demoonnn432', 700002),
  ('Zhuang Zhuang', '+79213278210', 'barsik894', 700003);

INSERT INTO public."Reader"("Nickname", "Login", "Password", "User ID")
VALUES 
  ('aboba', 'aboba@mail.ru', 'cookie241', 200001),
  ('misha228', 'misha228@gmail.com', 'cactus672', 200002),
  ('petus', '+79110327843', 'helicopter83', 200003);

-- Затем связанные таблицы
INSERT INTO public."Comics"("Name", "Comics ID", "Release date", "Team ID", "Description")
VALUES 
  ('Наруто', 400001, '1999-01-01', 100001, 'сёнэн-манга Масаси Кисимото...'),
  ('Окна напротив', 400002, '2016-02-01', 100002, 'друзья детства Гину и Юбин...'),
  ('Ветролом', 400003, '2013-03-02', 100003, 'драма о юных уличных гонщиках...');

INSERT INTO public."Chapter"("Chapter ID", "Comics ID", "Name")
VALUES 
  (1, 400001, 'Восхождение'),
  (2, 400001, 'Драма'),
  (3, 400001, 'Смерть'),
  (1, 400002, 'Встреча'),
  (2, 400002, 'Расставание');

INSERT INTO public."Subscription"("Price", "Payment date", "User ID", "Comics ID", "Payment ID")
VALUES 
  (150, '2024-01-01', 200002, 400001, 500001),
  (100, '2021-12-02', 200001, 400002, 500002),
  (120, '2005-12-23', 200001, 400003, 500003),
  (120, '2021-12-12', 200003, 400003, 500004),
  (100, '2022-05-13', 200002, 400002, 500005);

INSERT INTO public."Collection"("Collection ID", "Name", "User ID")
VALUES 
  (300001, 'Буду читать', 200001),
  (300002, 'Любимое', 200002),
  (300003, 'Читаю', 200003),
  (300004, 'Бросил', 200002),
  (300005, 'Прочитано', 200001);

INSERT INTO public."Collection Positions"("Collection ID", "Comics ID", "Note")
VALUES 
  (300001, 400001, 'прочитать до воскресенья'),
  (300001, 400003, ''),
  (300002, 400001, 'ОБОЖАЮ ЭТУ МАНГУ!!!!!!!!!!!!!!!!!!!!!!!!!'),
  (300003, 400002, ''),
  (300005, 400003, 'прочитал и ладно');

INSERT INTO public."Comment"("Date", "Text", "User ID", "Comment ID", "Comics ID")
VALUES 
  ('2025-03-04', 'КЛАССНО!!! ЛУЧШИЙ КОМИКС!!', 200001, 6000001, 400001),
  ('2023-12-03', 'очень скучно', 200002, 6000002, 400002),
  ('2019-05-17', 'кто-то понял, когда они поженятся?', 200003, 6000003, 400003),
  ('2022-06-08', 'сомнительно, но  окэй', 200001, 6000004, 400001),
  ('2024-12-23', 'БОЖЕ ОНИ ТАКИЕ КРАСИВЫЕ>>>>', 200002, 6000005, 400003);

INSERT INTO public."Team roles"("Team ID", "Content-maker ID", "Role name")
VALUES 
  (100001, 700001, 'Художник'),
  (100002, 700002, 'Переводчик'),
  (100003, 700003, 'Сценарист'),
  (100002, 700003, 'Художник'),
  (100001, 700003, 'Редактор');

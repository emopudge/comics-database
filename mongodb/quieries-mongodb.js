
---

## 📄 Файл `mongodb/queries-mongodb.js`

```javascript
// queries-mongodb.js: Основные операции в MongoDB для базы комиксов

// №1. Модификация коллекции: добавление атрибута
db.comics.updateMany(
  {}, 
  { $set: { "age restriction": 12 } }
);

// №2. Выборка всех данных из коллекции
db.chapter.find({});

// №3. Уникальные значения поля
db.getCollection("team-roles").distinct("Role name");

// №4 + №6. Фильтрация по описанию и дате выпуска
db.comics.find(
  {
    "Description": { $not: /комикс/i },
    "Release date": { $gte: "1999-01-01", $lte: "2016-12-31" }
  },
  { "_id": 0, "Name": 1, "Comics ID": 1, "Release date": 1, "Team ID": 1 }
);

// №5. Значения из заданного набора
db.getCollection("team-roles").find({ "Role name": { $in: ["painter", "translator"] } });

// №7. Непустые значения (пример для текста комментария)
db.comment.find({ "Text": { $ne: null, $ne: "" } });

// №8. Сортировка по двум полям
db.subscription.find()
  .sort({ "Price (rub)": -1, "Payment date": -1 })
  .projection({ "Price (rub)": 1, "Payment date": 1, "Subscription ID": 1, _id: 0 });

// №9. Внутреннее соединение (comics ←→ reader через subscription)
db.subscription.aggregate([
  {
    $lookup: {
      from: "reader",
      localField: "Reader ID",
      foreignField: "Reader ID",
      as: "readerData"
    }
  },
  { $unwind: "$readerData" },
  { $project: { _id: 0, "Comics ID": 1, "Nickname": "$readerData.Nickname" } }
]);

// №10. Правое соединение (все читатели, даже без подписок)
db.reader.aggregate([
  {
    $lookup: {
      from: "subscription",
      localField: "Reader ID",
      foreignField: "Reader ID",
      as: "subscriptionData"
    }
  },
  { $unwind: { path: "$subscriptionData", preserveNullAndEmptyArrays: true } },
  {
    $project: {
      _id: 0,
      "Price (rub)": "$subscriptionData.Price (rub)",
      "Comics ID": "$subscriptionData.Comics ID",
      "Reader ID": 1
    }
  }
]);

// №11. Левое соединение (все комиксы, даже без подписок)
db.comics.aggregate([
  {
    $lookup: {
      from: "subscription",
      localField: "Comics ID",
      foreignField: "Comics ID",
      as: "subscriptions"
    }
  },
  { $unwind: { path: "$subscriptions", preserveNullAndEmptyArrays: true } },
  { $project: { _id: 0, comics_title: "$Name", "Payment date": "$subscriptions.Payment date" } }
]);

// №12. Полное внешнее соединение (teams ↔ content-makers)
const teamsWithContentMakers = db['team'].aggregate([
  {
    $lookup: {
      from: 'content-maker',
      localField: 'Team ID',
      foreignField: 'Team ID',
      as: 'contentMakerInfo'
    }
  },
  { $unwind: { path: '$contentMakerInfo', preserveNullAndEmptyArrays: true } },
  {
    $project: {
      _id: 0,
      TeamID: '$Team ID',
      Name: 1,
      Nickname: { $ifNull: ['$contentMakerInfo.Nickname', 'No Nickname'] },
      Login: { $ifNull: ['$contentMakerInfo.Login', 'No Login'] }
    }
  }
]);

const contentMakersWithTeams = db['content-maker'].aggregate([
  {
    $lookup: {
      from: 'team',
      localField: 'Team ID',
      foreignField: 'Team ID',
      as: 'teamInfo'
    }
  },
  { $unwind: { path: '$teamInfo', preserveNullAndEmptyArrays: true } },
  {
    $project: {
      _id: 0,
      Nickname: 1,
      Login: 1,
      ContentMakerID: '$Content-maker ID',
      TeamID: { $ifNull: ['$teamInfo.Team ID', 'No Team ID'] },
      Name: { $ifNull: ['$teamInfo.Name', 'No Name'] }
    }
  }
]);

// Объединение результатов
const fullOuterJoinResults = teamsWithContentMakers.toArray().concat(contentMakersWithTeams.toArray());
printjson(fullOuterJoinResults);

// №13. Объединение коллекций
db["japanese-comics"].aggregate([
  { $project: { "Comics ID": 1, "Name": 1, "Release date": 1, "Team ID": 1, "Description": 1, rating: 1 } },
  {
    $unionWith: {
      coll: "comics",
      pipeline: [{ $project: { "Comics ID": 1, "Name": 1, "Release date": 1, "Team ID": 1, "Description": 1, rating: 1 } }]
    }
  },
  { $project: { _id: 1, name: 1, release_date: 1, team_id: 1, description: 1, rating: 1 } }
]);

// №14. Группировка по двум полям
db.comment.aggregate([
  { $lookup: { from: "reader", localField: "Reader ID", foreignField: "Reader ID", as: "readerData" } },
  { $lookup: { from: "comics", localField: "Comics ID", foreignField: "Comics ID", as: "comicsData" } },
  { $unwind: "$readerData" },
  { $unwind: "$comicsData" },
  {
    $group: {
      _id: { "Comics name": "$comicsData.Name", "Nickname": "$readerData.Nickname" },
      "Comment counts": { $sum: 1 }
    }
  },
  { $project: { "_id": 0, "Comment counts": 1, "Nickname": "$_id.Nickname", "Comics name": "$_id.Comics name" } }
]);

// №15. Вложенный подзапрос: пользователи, комментировавшие после 2025
db.comment.aggregate([
  { $match: { "Date": { $gt: "2025-01-01" } } },
  { $lookup: { from: "comics", localField: "Comics ID", foreignField: "Comics ID", as: "comicsData" } },
  { $unwind: "$comicsData" },
  { $group: { _id: "$Reader ID" } },
  { $lookup: { from: "reader", localField: "_id", foreignField: "Reader ID", as: "readerData" } },
  { $unwind: "$readerData" },
  { $group: { _id: "$readerData.Nickname" } },
  { $project: { "_id": 0, "Nickname": "$_id" } }
]);

// №16. Модифицируемое представление: художники
db.createView("painter_roles_view", "team-roles", [
  { $match: { "Role name": "painter" } },
  { $project: { "Team ID": 1, "Content-maker ID": 1, "Role name": 1, _id: 0 } }
]);

// Проверка
db.painter_roles_view.find();

// №17. Немодифицируемое представление: подсчёт глав
db.createView("comic_chapter_counter", "comics", [
  {
    $lookup: {
      from: "chapter",
      localField: "Comics ID",
      foreignField: "Comics ID",
      as: "chapters"
    }
  },
  { $project: { _id: 0, name: "$Name", chapter_count: { $size: "$chapters" } } }
]);

// Проверка
db.comic_chapter_counter.find();

migrate((db) => {
  const collection = new Collection({
    "id": "jgr5i73q7szxqs0",
    "created": "2023-06-08 13:04:10.247Z",
    "updated": "2023-06-08 13:04:10.247Z",
    "name": "messages",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "qmt8mjwo",
        "name": "message",
        "type": "editor",
        "required": false,
        "unique": false,
        "options": {}
      },
      {
        "system": false,
        "id": "owjauo5y",
        "name": "chat",
        "type": "relation",
        "required": false,
        "unique": false,
        "options": {
          "collectionId": "q8ussijba0xbnh3",
          "cascadeDelete": false,
          "minSelect": null,
          "maxSelect": 1,
          "displayFields": []
        }
      },
      {
        "system": false,
        "id": "f103afmx",
        "name": "user",
        "type": "relation",
        "required": false,
        "unique": false,
        "options": {
          "collectionId": "_pb_users_auth_",
          "cascadeDelete": false,
          "minSelect": null,
          "maxSelect": 1,
          "displayFields": []
        }
      }
    ],
    "indexes": [],
    "listRule": null,
    "viewRule": null,
    "createRule": null,
    "updateRule": null,
    "deleteRule": null,
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("jgr5i73q7szxqs0");

  return dao.deleteCollection(collection);
})

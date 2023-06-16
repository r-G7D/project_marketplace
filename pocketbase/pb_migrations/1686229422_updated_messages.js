migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("q8ussijba0xbnh3")

  collection.name = "chats"

  // remove
  collection.schema.removeField("1yclsguk")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "lkdh1gar",
    "name": "other_user",
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
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("q8ussijba0xbnh3")

  collection.name = "messages"

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "1yclsguk",
    "name": "message",
    "type": "editor",
    "required": false,
    "unique": false,
    "options": {}
  }))

  // remove
  collection.schema.removeField("lkdh1gar")

  return dao.saveCollection(collection)
})

migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("ho9xuc2r4p0unep")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "3kocx0jy",
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
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("ho9xuc2r4p0unep")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "3kocx0jy",
    "name": "field",
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
})

migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("_pb_users_auth_")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "uor2sbyu",
    "name": "products",
    "type": "relation",
    "required": false,
    "unique": false,
    "options": {
      "collectionId": "broi8sg0cvuaotb",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": null,
      "displayFields": []
    }
  }))

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "mtfjrbm3",
    "name": "saved",
    "type": "relation",
    "required": false,
    "unique": false,
    "options": {
      "collectionId": "broi8sg0cvuaotb",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": null,
      "displayFields": []
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("_pb_users_auth_")

  // remove
  collection.schema.removeField("uor2sbyu")

  // remove
  collection.schema.removeField("mtfjrbm3")

  return dao.saveCollection(collection)
})

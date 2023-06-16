migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("broi8sg0cvuaotb")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "ctyfoock",
    "name": "comments",
    "type": "relation",
    "required": false,
    "unique": false,
    "options": {
      "collectionId": "ho9xuc2r4p0unep",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": null,
      "displayFields": []
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("broi8sg0cvuaotb")

  // remove
  collection.schema.removeField("ctyfoock")

  return dao.saveCollection(collection)
})

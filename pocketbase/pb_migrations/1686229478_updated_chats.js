migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("q8ussijba0xbnh3")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "b8mspsuj",
    "name": "messages",
    "type": "relation",
    "required": false,
    "unique": false,
    "options": {
      "collectionId": "jgr5i73q7szxqs0",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": null,
      "displayFields": []
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("q8ussijba0xbnh3")

  // remove
  collection.schema.removeField("b8mspsuj")

  return dao.saveCollection(collection)
})

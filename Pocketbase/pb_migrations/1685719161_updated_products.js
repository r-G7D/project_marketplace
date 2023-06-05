migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("broi8sg0cvuaotb")

  collection.listRule = null

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("broi8sg0cvuaotb")

  collection.listRule = "@request.auth.id != \"\""

  return dao.saveCollection(collection)
})

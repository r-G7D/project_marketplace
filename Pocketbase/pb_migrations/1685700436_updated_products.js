migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("broi8sg0cvuaotb")

  collection.viewRule = "@request.auth.id != \"\""
  collection.createRule = "user = @request.auth.id"

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("broi8sg0cvuaotb")

  collection.viewRule = null
  collection.createRule = null

  return dao.saveCollection(collection)
})

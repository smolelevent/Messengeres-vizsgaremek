/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_2497630811")

  // update field
  collection.fields.addAt(1, new Field({
    "cost": 0,
    "hidden": true,
    "id": "password901924565",
    "max": 20,
    "min": 8,
    "name": "password",
    "pattern": "^[\\p{L}\\p{N}\\p{P}\\p{S}]*[A-Z][\\p{L}\\p{N}\\p{P}\\p{S}]*[a-z][\\p{L}\\p{N}\\p{P}\\p{S}]*\\d[\\p{L}\\p{N}\\p{P}\\p{S}]{7,17}$",
    "presentable": false,
    "required": true,
    "system": true,
    "type": "password"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_2497630811")

  // update field
  collection.fields.addAt(1, new Field({
    "cost": 0,
    "hidden": true,
    "id": "password901924565",
    "max": 20,
    "min": 8,
    "name": "password",
    "pattern": "^[\\p{L}\\p{N}\\p{P}\\p{S}]{8,20}$",
    "presentable": false,
    "required": true,
    "system": true,
    "type": "password"
  }))

  return app.save(collection)
})

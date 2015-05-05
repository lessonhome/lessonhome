db.dropUser('feel');

db.createUser(
  {
    user: "feel",
    pwd: "Avezila2734&",
    roles: [ { role: "readWrite", db: "feel" } ]
  }
)




db.dropUser('admin');

db.createUser(
  {
    user: "admin",
    pwd: "Monach2734&",
    roles:  [ 
      { role: "userAdminAnyDatabase", db: "admin" },
      { role: "root", db:"admin"}
    ]
  }
);


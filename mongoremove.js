var arr = db.getCollectionNames();
for (var i in arr){
  if (!arr[i].match(/system\./))
    db[arr[i]].drop();
};
  

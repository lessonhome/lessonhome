

function drop(key){
  db[key].drop();
  print('dropped',key);
}
function dropFeel(){
  var names = db.getCollectionNames();
  for(i in names){
    var v = names[i];
    if (v.match(/^feel-.*/))
      drop(v);
  }
}

dropFeel();





class Find
  get : (o) => {$and : [{moderate : true}, {$or : [{id : $exists : false}, {id : ""}]}]}


module.exports = Find



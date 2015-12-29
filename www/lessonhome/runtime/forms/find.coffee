


class Find
  get : (o)=> $or:[{account:o.id},{id:o.id}]


module.exports = Find



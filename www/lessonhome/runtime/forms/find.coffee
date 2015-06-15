


class Find
  get : (req,res)=> $or:[{account:req.user.id},{id:req.user.id}]


module.exports = Find



module.exports = (user, admin=false) =>
  throw new Error('Permission denied') if admin and !user.admin
  throw new Error('Not exist user.id. Please, transfer correct user ') unless user.id?
  return true
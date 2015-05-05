

class Db
  constructor : ->
    Wrap @
    @connections = {}
    @connecting  = {}
    @user     = "feel"
    @password = "Avezila2734&"
    @client = require('mongodb').MongoClient
  init : =>
    @log()
    @feel = yield @connect 'feel'
  connect : (dbname)=>
    return @connections[dbname] if @connections[dbname]
    connecting = @connecting[dbname]?
    @connecting[dbname] ?= []
    defer = Q.defer()
    @connecting[dbname].push defer
    return defer.promise if connecting
    url = "mongodb://#{@user}:#{@password}@127.0.0.1:27081/#{dbname}?wtimeoutMS=1000"#?connectTimeoutMS=1000&socketTimeoutMS=1000"
    @client.connect url,uri_decode_auth:true, (err,db)=>
      if err?
        @error err
        defer.reject err for defer in @connecting[dbname]
      else
        @log dbname
        @connections[dbname] = db
        defer.resolve db for defer in @connecting[dbname]
      delete @connecting[dbname]
    return defer.promise
  get   : (name)=>
    n = "_c_#{name}"
    @get[n] ?= @feel.collection name
    return @get[n]
  close : =>
    for name,connect of @connections
      connect.close()


module.exports = Db



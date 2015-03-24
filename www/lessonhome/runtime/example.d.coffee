


@main = (table)=>
  @db = yield @$db.get table 
  data = yield _invoke @db.find(), 'toArray'
  return data


@select = (table)=>
  @db = yield @$db.get table
  yield _invoke @db.find(), 'toArray'


###

send 'test', (err,data)->
  console.log data
  if err
    return console.error err
  exists 'name', (err,exists)->
    if err
      return console.error err
    if exists
      stat 'name', (err,stat)->
        if err
          return console.error err
        if stat.isFile()
          readfile 'namme', (err,file)->
            if err
              return console.error err
            connectdb 'dbname', (err,db)->
              if err
                return console.error err
              db.write file, (err,result)->
                if err
                  return console.error err
                if result
                  res.end {status:'success'}


_readfile = Q.denode readfile

result = yield _invoke db, 'write', file

wait(1000)
.then ->
  send(test)
.then (data)->
  exists 'name'
.then (exists)->
  stat 'name' if exists
.then (stat)->
  read 'file' if stat.isFile()
.catch (err)->
  console.error err

  Q.denode
  
wait = (dt)->
  defer = Q.defer()
  setTimeout ->
    defer.reject new Error 'error'
  ,dt
  return defer.promise.then (msg)->

foo =  Q.async =>
  yield wait 1000
  data = yield send 'test'
  exists = yield exists 'name'


foo = ->
  return

  return Q(10)
###
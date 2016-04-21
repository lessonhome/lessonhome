
Io        = require './io'
Bids      = require './bids'
Chats     = require './chats'
Pupils    = require './pupils'
Interface = require './interface'

_ObjectID = require('mongodb').ObjectID

class PupilWorker
  init : =>
    @jobs   = yield _Helper 'jobs/main'
    @redis  = yield _Helper('redis/main').get()
    @db     = yield Main.service 'db'
    
    @dbBids = yield @db.get 'bids'
    @dbChat = yield @db.get 'chat'
    @dbPupil = yield @db.get 'pupil'

    @pupils     = $W new Pupils    @
    @bids       = $W new Bids      @
    @chats      = $W new Chats     @
    @interface  = $W new Interface @
    @io         = $W new Io        @

    yield @io.init()
    yield @pupils.init()
    yield @bids.init()
    yield @chats.init()
    yield @interface.init()

    yield @io.run()
    yield @pupils.run()
    yield @bids.run()
    #yield @chats.run()
    #yield @interface.run()


  _getID : (_id)-> new _ObjectID _id
  hash : (data={},but={__hash:true})=>
    o = {}
    for key,val of data
      if !but[key]
        o[key] = val
      else
        o[key] = true

    return _object_hash o

module.exports = PupilWorker


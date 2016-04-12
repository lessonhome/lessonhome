
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

    yield @pupils.init()
    yield @bids.init()
    yield @chats.init()
    yield @interface.init()
    yield @io.init()


  _getID : (_id)-> new _ObjectID _id

module.exports = PupilWorker


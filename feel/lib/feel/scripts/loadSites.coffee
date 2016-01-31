
fs      = require 'fs'
readdir = Q.denodeify(fs.readdir)
Site    = require '../class/site.coffee'

module.exports = ->
  Q()
  .then ->  readdir Feel.path.www
  .then (sites)->
    for sitename in sites
      Feel.site[sitename] = new Site sitename
    sites.reduce (promise,sitename)=>
      promise.then Feel.site[sitename].init
    , Q()

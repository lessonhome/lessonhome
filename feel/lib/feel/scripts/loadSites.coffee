
fs      = require 'fs'
readdir = Q.denodeify(fs.readdir)
Site    = require '../class/site.coffee'

module.exports = -> do Q.async =>
  sites = yield  readdir Feel.path.www
  for sitename in sites
    continue unless sitename.match /^\w+$/
    Feel.site[sitename] = new Site sitename
    yield Feel.site[sitename].init()

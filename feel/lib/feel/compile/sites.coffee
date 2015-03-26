

Site = require './site'

class Sites
  constructor : ->
    Wrap @
    @site = {}
  init : =>
    @watcher = yield Main.service 'watcher'
    dir = yield @watcher.dir('www').then (dir)=> dir.get()
    qs = []
    for site in dir.dirs
      site = _path.basename site
      continue unless site.match /^\w+$/
      @site[site] = new Site site
      qs.push @site[site].init()
    yield Q.all qs
  run : =>
    for name,site of @site
      yield site.run?()
module.exports = Sites

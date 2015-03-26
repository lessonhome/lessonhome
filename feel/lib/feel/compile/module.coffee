

ModuleJs = require './moduleJs'

class Module
  constructor : (@name,@site)->
    Wrap @
    @path =
      module : "#{@site.path.modules}/#{@name}"
    @js = new ModuleJs @
  init : =>
    @log @name
    @watcher = @site.watcher
    @dir = yield @watcher.dir @path.module
    @dir.on 'change', =>
      yield @dirRead()
      yield @js.compile()
    yield @dirRead()
    yield @js.init()
  dirRead : =>
    @files = (yield @dir.get()).files
  run : =>
    yield @js.run()

module.exports = Module



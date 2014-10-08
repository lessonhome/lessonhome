
jade = require 'jade'

class module.exports
  constructor : (module,@site)->
    @files  = module.files
    @name   = module.name
    @jade   = {}
  init : =>
    console.log "init module '#{@name}'", @files
    Q()
    .then @makeJade
  makeJade : =>
    for filename, file of @files
      if file.ext == 'jade' && file.name == 'main'
        console.log "JADE!!! #{@name} #{file.path}"
        @jade.fn    = jade.compileFile file.path
        @jade.fnCli = jade.compileFileClient file.path
    console.log @doJade({
      "$title":"$title"
      m :
        head : "m:head"
    })
  doJade : (o)=>
    if @jade.fn?
      return " <div id=\"m-#{@name}\" >
          #{@jade.fn(o)}
        </div>
      "
    return ""

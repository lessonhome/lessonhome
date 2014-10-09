
jade = require 'jade'

class module.exports
  constructor : (module,@site)->
    @files  = module.files
    @name   = module.name
    @jade   = {}
  init : =>
    Q()
    .then @makeJade
  makeJade : =>
    for filename, file of @files
      if file.ext == 'jade' && file.name == 'main'
        @jade.fn    = jade.compileFile file.path, {
          compileDebug : true
        }
        @jade.fnCli = jade.compileFileClient file.path, {
          compileDebug : true
        }
  doJade : (o)=>
    if @jade.fn?
      try
        return " <div id=\"m-#{@name}\" >
            #{@jade.fn(o)}
          </div>
        "
      catch e
        throw new Error "Failed execute jade in module #{@name} with vars #{JSON.stringify(o)}:\n\t"+e
    return ""

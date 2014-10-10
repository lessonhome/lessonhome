
jade  = require 'jade'
fs    = require 'fs'


class module.exports
  constructor : (module,@site)->
    @files  = module.files
    @name   = module.name
    @id     = module.name.replace /\//g, '-'
    @jade   = {}
    @css    = {}
    @allCss = ""
  init : =>
    Q()
    .then @makeJade
    .then @makeSass
    .then @makeAllCss
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
        return " <div id=\"m-#{@id}\" >
            #{@jade.fn(o)}
          </div>
        "
      catch e
        throw new Error "Failed execute jade in module #{@name} with vars #{JSON.stringify(o)}:\n\t"+e
    return ""
  makeSass : =>
    for filename, file of @files
      if file.ext == 'sass'
        path = "#{@site.path.sass}/#{@name}/#{file.name}.css"
        try
          src = fs.readFileSync(path).toString()
        catch e
          throw new Error "failed read css in module #{@name}: #{file.name}(#{path})",e
        @css[filename] = @parseCss src
    return Q()
  makeAllCss : =>
    for name,src of @css
      @allCss += "/*#{name}*/\n#{src}\n"
  parseCss : (css)=>
    ret = ''
    m = css.match /([^{]*)([^}]*})(.*)/
    return css unless m
    pref = m[1]
    body = m[2]
    post = m[3]
  
    newpref = ""
    m = pref.match /([^,]+)/g
    if m
      for sel in m
        if newpref != ""
          newpref += ","
        newpref += "#m-#{@id}"
        continue if sel == 'main'
        m2 = sel.match /([^\s]+)/g
        if m2
          for a in m2
            newpref += ">"+a
        else newpref += ">"+sel
    else newpref = pref

    ret = newpref+body+@parseCss(post)


    return ret


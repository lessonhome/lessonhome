
jade    = require 'jade'
fs      = require 'fs'
readdir = Q.denodeify fs.readdir
readfile= Q.denodeify fs.readFile
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
  rescanFiles : =>
    readdir "#{@site.path.modules}/#{@name}"
    .then (files)=>
      @files = {}
      for f in files
        m = f.match /^([^\.].*)\.(\w*)$/
        if m
          @files[f] = {
            name  : m[1]
            ext   : m[2]
            path  : "#{@site.path.modules}/#{@name}/#{f}"
          }
        else if f.match /^[^\.].*$/
          @files[f] = {
            name  : f
            ext   : ""
            path  : "#{@site.path.modules}/#{@name}/#{f}"
          }
  makeJade : =>
    @jade = {}
    for filename, file of @files
      if file.ext == 'jade' && file.name == 'main'
        console.log "jade #{@name}"
        @jade.fn    = jade.compileFile file.path, {
          compileDebug : true
        }
        @jade.fnCli = jade.compileFileClient file.path, {
          compileDebug : true
        }
        break
  rebuildJade : =>
    @rescanFiles()
    .then @makeJade
  doJade : (o)=>
    o.F = (f)=> Feel.static.F @site.name, f
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
  makeSassAsync : =>
    files = []
    for filename,file of @files
      files.push file
    return files.reduce (promise,file)=>
      return promise unless file.ext == 'sass'
      path = "#{@site.path.sass}/#{@name}/#{file.name}.css"
      return promise.then => readfile path
      .then (src)=>
        src = src.toString()
        @css[file.name+'.'+file.ext] = @parseCss src
    , Q()
    .then @makeAllCss
  makeAllCss : =>
    @allCss = ""
    for name,src of @css
      @allCss += "/*#{name}*/\n#{src}\n"
  parseCss : (css)=>
    ret = ''
    css = css.replace /\$FILE--\"([^\$]*)\"--FILE\$/g, "\"/file/666/$1\""
    css = css.replace /\$FILE--([^\$]*)--FILE\$/g, "\"/file/666/$1\""
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


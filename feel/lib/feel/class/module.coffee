
jade_runtime  = require './runtime.js'
jade          = require 'jade'
for key,val of jade_runtime
  if typeof val == "function"
    do (key,val)=>
      jade[key] = => val.apply jade_runtime, arguments
fs      = require 'fs'
coffee  = require 'coffee-script'
_path    = require 'path'
readdir = Q.denodeify fs.readdir
readfile= Q.denodeify fs.readFile


class module.exports
  constructor :   (module,@site)->
    @files      = module.files
    @name       = module.name
    @id         = module.name.replace /\//g, '-'
    @jade       = {}
    @css        = {}
    @coffee     = {}
    @js         = {}
    @allCss     = ""
    @allCoffee  = ""
    @allJs      = ""

  init : =>
    Q()
    .then @makeJade
    .then @makeSass
    .then @makeAllCss
    .then @makeCoffee
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
  replacer : (str,p,offset,s)=> str.replace(/([\"\ ])(m-[\w-]+)/,"$1mod-#{@id}--$2")
  makeJade : =>
    @jade = {}
    for filename, file of @files
      if file.ext == 'jade' && file.name == 'main'
        @jade.fnCli = Feel.cacheFile file.path
        break if @jade.fnCli?
        console.log "jade #{@name}"

        @jade.fnCli = jade.compileFileClient file.path, {
          compileDebug : false
        }
        while true
          n = @jade.fnCli.replace(/class\=\\\"(?:[\w-]+ )*(m-[\w-]+)(?: [\w-]+)*\\\"/, @replacer)
          break if n == @jade.fnCli
          @jade.fnCli = n
        Feel.cacheFile file.path, @jade.fnCli
        break
    if @jade.fnCli?
      @jade.fn = eval "(#{@jade.fnCli})"
  rebuildJade : =>
    @rescanFiles()
    .then @makeJade
  doJade : (o)=>
    o.F = (f)=> Feel.static.F @site.name,f
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
          console.error e
          throw new Error "failed read css in module #{@name}: #{file.name}(#{path})",e
        @css[filename] = @parseCss src,filename
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
        @css[file.name+'.'+file.ext] = @parseCss src,filename
    , Q()
    .then @makeAllCss
  makeAllCss : =>
    @allCss = ""
    for name,src of @css
      @allCss += "/*#{name}*/\n#{src}\n"
  parseCss : (css,filename)=>
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
        unless sel.match /^\.(g-[\w-]+)/
          newpref += "#m-#{@id}"
        continue if sel == 'main'
        m2 = sel.match /([^\s]+)/g
        if m2
          for a in m2
            m3 = a.match /^\.(m-[\w-]+)/
            if m3
              newpref += " \.mod-#{@id}--#{m3[1]}"
            else if a.match /^\.(g-[\w-]+)/
              newpref += " "+a
            else
              newpref += ">"+a
        else
          m3 = sel.match /^\.m-[\w-]+/
          if m3
            newpref += " \.mod-#{@id}--#{m3[1]}"
          else if sel.match /^\.(g-[\w-]+)/
            newpref += " "+sel
          else
            newpref += ">"+sel
    else newpref = pref
    newpref=pref if filename.match /.*\.g\.sass$/
    ret = newpref+body+@parseCss(post,filename)


    return ret
  makeCoffee  : =>
    @newCoffee = {}
    for filename, file of @files
      if file.ext == 'coffee'
        src = ""
        try
          src = Feel.cacheCoffee file.path
        catch e
          console.error e
          throw new Error "failed read coffee in module #{@name}: #{file.name}(#{path})",e
        @newCoffee[filename] = src
      if file.ext == 'js'
        src = ""
        try
          src = fs.readFileSync file.path
        catch e
          console.error e
          throw new Error "failed read js in module #{@name}: #{file.name}(#{path})",e
        @newCoffee[filename] = src
    @coffee     = @newCoffee
    @allCoffee  = "(function(){ var arr = {}; (function(){"
    @allJs      = ""
    num = 0
    for name,src of @coffee
      m = name.match /^(.*)\.(coffee|js)/
      if m
        num++
        @allJs += "(function(){ #{src} }).call(this);"
    @allCoffee += @allJs
    @allCoffee += "}).call(arr);return arr; })()"
    @allCoffee = "" unless num

    return Q()
  makeJs  : =>
    @newJs = {}
    for filename, file of @files
      if file.ext == 'js'
        src = ""
        try
          src = fs.readFileSync file.path
        catch e
          console.error e
          throw new Error "failed read js in module #{@name}: #{file.name}(#{path})",e
        @newJs[filename] = src
    @js     = @newJs
    @allJs  = "(function(){ var arr = {};"
    num = 0
    for name,src of @js
      m = name.match /^(.*)\.js/
      if m
        num++
        @allJs += "(function(){ #{src} }).call(arr);"
    @allJs += "return arr; })()"
    @allJs  = "" unless num

    return Q()

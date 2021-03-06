
jade_runtime  = require './runtime.js'
jade          = require 'jade'
for key,val of jade_runtime
  if typeof val == "function"
    do (key,val)=>
      jade[key] = => val.apply jade_runtime, arguments
fs      = require 'fs'
coffee  = require 'coffee-script'
crypto  = require 'crypto'
_path    = require 'path'
readdir = Q.denodeify fs.readdir
readfile= Q.denodeify fs.readFile

escapeRegExp = (string)-> string.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1")
replaceAll   = (string, find, replace)->
  string.replace(new RegExp(escapeRegExp(find), 'g'), replace)

global.ttt = 0

htmlComment = new RegExp '<!--[\\s\\S]*?(?:-->)?' + '<!---+>?' + '|<!(?![dD][oO][cC][tT][yY][pP][eE]|\\[CDATA\\[)[^>]*>?' + '|<[?][^>]*>?', 'g'

class module.exports
  constructor :   (module,@site)->
    @version = 5
    @files      = module.files ? {}
    @name       = module.name
    @hashsum    = _hash(module.stat || "")+@version
    @id         = module.name.replace /\//g, '-'
    @jade       = {}
    @css        = {}
    @cssSrc     = {}
    @allCssRelative = {}
    @coffee     = {}
    @coffeenr     = {}
    @js         = {}
    @allCss     = ""
    @allCoffee  = ""
    @allJs      = ""
    @jsHash     = '666'
    @coffeeHash = '666'
    @vars_to_cache = [
      'jade'
      'hashsum'
      'allCssRelative','cssSrc','css','allCss'
      'config','newCoffee','newCoffeenr','coffee','coffeenr','allCoffee','allJs','jsHash','coffeeHash'
    ]
  init : => do Q.async =>
    @cache = @site.module_redis_cache[@name] ? {}
    
    if @cache.hashsum == @hashsum
      @[field] = @cache[field] for field in @vars_to_cache
      @jade.fn = eval "(#{@jade.fnCli})" if @jade.fnCli
      console.log 'module\t'.yellow,"#{@name}".grey
    else
      yield @makeJade()
      yield @makeSassAsync()
      yield @makeAllCss()
      yield @makeCoffee()
      @cache = {}
      @cache[field] = @[field] for field in @vars_to_cache
      Q.spawn =>
        yield _invoke @site.redis,'hset',"module_cache",@name,JSON.stringify @cache

  rescanFiles : => do Q.async =>
    files = yield readdir "#{@site.path.modules}/#{@name}"
    @files = {}
    files.sort()
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
  replacer  : (str,p,offset,s)=> str.replace(/([\"\ ])(m-[\w-:\.]+)/,"$1mod-#{@id}--$2")
  replacer3  : (str,p,offset,s)=> str.replace(/([\'])(m-[\w-:\.]+\')/,"$1mod-#{@id}--$2")
  replacer2 : (str,p,offset,s)=> str.replace(/([\"\ ])js-([\w-:\.]+)/,"$1js-$2--{{UNIQ}} $2")
  makeJade : (source=false)=>
    _jade = {}
    for filename, file of @files
      if file.ext == 'jade' && file.name == 'main'
        _jade.fnCli = Feel.cacheFile file.path
        break if _jade.fnCli?
        console.log "jade\t\t".blue,"#{@name}".grey

        _jade.fnCli = jade.compileFileClient file.path, {
          compileDebug : false
        }
        while true
          n = _jade.fnCli.replace(/class\=\\\"(?:[\w-:\.]+ )*(m-[\w-:\.]+)(?: [\w-:\.]+)*\\\"/, @replacer)
          break if n == _jade.fnCli
          _jade.fnCli = n
        while true
          n = _jade.fnCli.replace(/jade\.cls\(\[(?:[\w-:\.\s]+\,)*(\'m-[\w-:\.]+\')(?:\,[\w-:\.\s]+)*\]/, @replacer3)
          break if n == _jade.fnCli
          _jade.fnCli = n
        while true
          n = _jade.fnCli.replace(/class\=\\\"(?:[\w-:\.]+ )*(js-[\w-:\.]+)(?: [\w-:\.]+)*\\\"/, @replacer2)
          break if n == _jade.fnCli
          _jade.fnCli = n
        while true
          n = _jade.fnCli.replace(/class\"\s*\:\s*\"(?:[\w-:\.]+ )*(js-[\w-:\.]+)(?: [\w-:\.]+)*\"/, @replacer2)
          break if n == _jade.fnCli
          _jade.fnCli = n
        ###
        m = _jade.fnCli.match(/class=\\\"([\w-:\s]+)\\\"/mg)
        console.log m
        if m then for m_ in m
          m_ = m_.match /(js-\w+)/mg
          console.log m_
        ###
        Feel.cacheFile file.path, _jade.fnCli
        break
    if _jade.fnCli?
      _jade.fn = eval "(#{_jade.fnCli})"
    @jade = _jade
  rebuildJade : =>
    @_rebuildingJade = true
    @rescanFiles()
    .then @makeJade
    .catch (e)=>
      console.error Exception e
      #setTimeout =>
      #  @rebuildJade() unless @_rebuildingJade
      #, 3000
    .then =>
      @_rebuildingJade = false
  rebuildCoffee : =>
    @_rebuildingCoffee = true
    @rescanFiles()
    .then @makeCoffee
    .catch (e)=>
      console.error Exception e
      #setTimeout =>
      #  @rebuildCoffee() unless @_rebuildingCoffee
      #, 3000
    .then =>
      @_rebuildingCoffee = false

  doJade : (o,route,state)=>
    eo    =
      F     : (f)=> Feel.static.F @site.name,f
      data  : (s)=> @site.dataObject s,_path.relative "#{@site.path.modules}/../","#{@site.path.modules}/#{@name}"
      $tag  : (f)=>
        if typeof f == 'string'
          return state.tag[f]?
        if f instanceof RegExp
          for key of state.tag
            return key.match(f)?
          return false
        return false
      $pageTag  : (f)=>
        if typeof f == 'string'
          return state.page_tags[f]?
        if f instanceof RegExp
          for key of state.page_tags
            return key.match(f)?
          return false
        return false
      $req      : route.req
      $res      : route.res
      $state    : state
      $modulename : @name
      $statename  : state.name
    eo extends o
    if @jade.fn?
      try
        text = @jade.fn(eo)
        return "<div id=\"m-#{@id}\">#{text}</div>"
      catch e
        throw new Error "Failed execute jade in module #{@name} with vars #{Object.keys(o)}:\n\t"+e
        console.error e
    return ""
  matchTagAttr : (tag,attr)=>
    out = ''
    reg = "#{attr}=\"([^\"]+)\""
    m = tag.match new RegExp reg,'mi'
    if m
      c = m[1].split ' '
      for it in c
        continue unless it
        out += ' ' if out
        out += it
    return out || null

  matchClasses : (src,id)=>
    src = src.replace htmlComment,''
    console.log id
    level = []
    body = src || ""
    out = ''
    while m = body.match /^(\<\w+[^\>]*\>)(.*)/m
      tag = m[1]
      next = m[2]
      name = tag.match(/^\<(\w+)/)[1]
      if m2 = name.match /(MM_\w+)/
        m3 = next.match (new RegExp("(.*\\<\\/#{m2[1]}\\>)(.*)",'m'))
        unless m3
          console.error 'cant find </MM_hash in '+next
        out += tag+m3[1]
        body = m3[2]
        continue
      classes = @matchTagAttr tag,'class'
      if classes
        arr = classes.split ' '
        classes = {}
        for a in arr
          classes[a] = true
      console.log name,tag,classes
      body = next
    out += body
    return out

    
  makeSass : =>
    @allCssRelative = {}
    @cssSrc         = {}
    @css            = {}
    qs = []
    for filename, file of @files
      if (file.ext == 'sass') || (file.ext == 'scss') || (file.ext == 'css')
        qs.push do (filename,file)=> do Q.async =>
          path = "#{@site.path.sass}/#{@name}/#{file.name}.css"
          data = Feel.qCacheFile path,null,'css'
          datasrc = yield Feel.qCacheFile path,null,'csssrc'
          unless datasrc
            try
              src = (yield _readFile(path)).toString()
            catch e
              console.error e
              throw new Error "failed read css in module #{@name}: #{file.name}(#{path})",e
            @cssSrc[filename] = src
            yield Feel.qCacheFile path,src,'csssrc'
          else
            @cssSrc[filename] = datasrc
          data = yield data
          unless data
            @css[filename] = yield @parseCss @cssSrc[filename],filename
            if _production
              @css[filename] = yield Feel.ycss @css[filename]
            else
              @css[filename] = Feel.bcss @css[filename]
            yield Feel.qCacheFile path,@css[filename],'css'
          else
            @css[filename] = data
    return Q.all qs
  makeSassAsync : => do Q.async =>
    @allCssRelative = {}
    @cssSrc = {}
    @css    = {}
    qs = []
    for filename,file of @files
      continue unless (file.ext == 'sass') || (file.ext=='scss') || (file.ext=='css')
      qs.push do (filename,file)=> do Q.async =>
        path = "#{@site.path.sass}/#{@name}/#{file.name}.css"
        data = Feel.qCacheFile path,null,'css'
        datasrc = yield Feel.qCacheFile path,null,'csssrc'
        unless datasrc
          try
            src = (yield _readFile(path)).toString()
          catch e
            console.error e
            throw new Error "failed read css in module #{@name}: #{file.name}(#{path})",e
          @cssSrc[filename] = src
          yield Feel.qCacheFile path,src,'csssrc'
        else
          @cssSrc[filename] = datasrc
        data = yield data
        unless data
          @css[filename] = yield @parseCss @cssSrc[filename],filename
          if _production
            @css[filename] = yield Feel.ycss @css[filename]
          else
            @css[filename] = Feel.bcss @css[filename]
          yield Feel.qCacheFile path,@css[filename],'css'
        else
          @css[filename] = data
    yield Q.all qs
    yield @makeAllCss()
  getAllCssExt : (exts)=> do Q.async =>
    css = ""
    for ext of exts
      css += yield @site.modules[ext]?.getCssRelativeTo? @name if @site.modules[ext]?.getCssRelativeTo?
    css = Feel.bcss css
    return css
  getCssRelativeTo : (rel)=> do Q.async =>
    return @allCssRelative[rel] if @allCssRelative?[rel]?
    @allCssRelative ?= {}
    @allCssRelative[rel] = ""
    for filename,src of @cssSrc
      @allCssRelative[rel] += "/*#{@name}:#{filename} relative to #{rel}*/"
      @allCssRelative[rel] += yield @parseCss src,filename,@site.modules[rel].id
    return @allCssRelative[rel]
  makeAllCss : =>
    @allCss = ""
    for name,src of @css
      @allCss += "/*#{name}*/#{src}"
  parseCss : (css,filename,relative=@id,...,ifloop)=> do Q.async =>
    ret = ''
    m = css.match /\$FILE--\"([^\$]*)\"--FILE\$/g
    if m then for f in m
      fname = f.match(/\$FILE--\"([^\$]*)\"--FILE\$/)[1]
      css = replaceAll css,f,"#{yield Feel.static.FP(@site.name,fname)}"
    m = css.match /\$FILE--([^\$]*)--FILE\$/g
    if m then for f in m
      fname = f.match(/\$FILE--([^\$]*)--FILE\$/)[1]
      css = replaceAll css,f,"#{yield Feel.static.FP(@site.name,fname)}"
    css = css.replace /\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\//gmi,''
    css = css.replace /\n/gmi,' '
    css = css.replace /\r/gmi,' '
    css = css.replace /\s+/gmi,' '
    #css = css.replace /\$FILE--\"([^\$]*)\"--FILE\$/g, "\"/file/666/$1\""
    #css = css.replace /\$FILE--([^\$]*)--FILE\$/g, "\"/file/666/$1\""
    return css if filename.match(/.*\.g\.(sass|scss|css)$/)
    #if m = css.match /^(\@media[^\{]+\{)([^\}]+\})(\})(.*)/
    if m = css.match /^(\@media[^\{]+\{)((?:[^\}]+\})*)(\})(.*)/
      unless m[1] || m[3]
        m[1] = ''
        m[3] = ''
      m[4] = m[4] || ''
      m[2] = m[2] || ''
      inline = yield @parseCssLoop '',m[2],filename,relative
      ret = m[1]+inline+m[3]
      return yield @parseCssLoop ret,m[4],filename,relative,ifloop
      
    m = css.match /([^{]*)([^}]*})(.*)/
    return css unless m
    pref = m[1]
    body = m[2]
    post = m[3]
    newpref = ""
    # перебор селекторов
    m = pref.match /([^,]+)/g
    if m
      for sel in m
        # добавление очередного селектора
        if newpref != ""
          newpref += ","
        replaced = false
        if sel.match /^main.*/
          sel = sel.replace /^main/, "#m-#{relative}"
          replaced = true
        if !(sel.match /^\.(g-[\w-:\.]+)/) && (!replaced)
          newpref += "#m-#{relative}"
        #continue if sel == 'main'
        m2 = sel.match /([^\s]+)/g
        if m2
          for a in m2
            m3 = a.match /^\.(m-[\w-:\.]+)/
            leftpref = ""
            if m3
              leftpref = " " unless replaced
              newpref += leftpref+"\.mod-#{relative}--#{m3[1]}"
            else if a.match /^\.(g-[\w-:\.]+)/
              leftpref = " " unless replaced
              newpref += leftpref+a
            else
              leftpref = ">" unless replaced
              newpref += leftpref+a
        else
          m3 = sel.match /^\.m-[\w-:\.]+/
          leftpref = ""
          if m3
            leftpref = " " unless replaced
            newpref += leftpref+"\.mod-#{relative}--#{m3[1]}"
          else if sel.match /^\.(g-[\w-:\.]+)/
            leftpref = " " unless replaced
            newpref += leftpref+sel
          else if sel && !replaced
            leftpref = ">" unless replaced
            newpref += leftpref+sel
    else newpref = pref
    newpref=pref if filename.match(/.*\.g\.(sass|scss|css)$/)
    return yield @parseCssLoop newpref+body,post,filename,relative,ifloop
  parseCssLoop : (ret,post,filename,relative,ifloop)=> do Q.async =>
    if ifloop == 'loop'
      return {
        begin : ret
        args  : [post,filename,relative,'loop']
      }
    #ret = newpref+body
    args = [post,filename,relative,'loop']
    loop
      ret2 = yield @parseCss args... #(post,filename,relative,'loop')
      if ret2?.args?
        ret+=ret2.begin
        args = ret2.args
      else
        ret+= ret2
      break unless ret2?.args?
    return ret
  makeCoffee  : => do Q.async =>
    if @files['config.coffee']
      conffile = require.resolve "#{process.cwd()}/#{@files['config.coffee'].path}"
      delete require.cache[conffile]
      @config = require conffile
    @config ?= {}
    for key,val of (@config.isomorph ? {})
      @files["#{val}.coffee"] = {
        name : val
        ext  : 'coffee'
        path : "#{@site.path.isomorph}/#{key}.coffee"
      }
    @newCoffee = {}
    @newCoffeenr = {}
    qs = []
    for filename, file of @files
      if file.ext == 'coffee' && !filename.match(/.*\.[d|c]\.coffee$/)
        do (filename,file)=> qs.push do Q.async =>
          console.log 'coffee\t'.yellow,"#{@name}/#{filename}".grey
          src = ""
          datasrc = yield Feel.qCacheFile file.path,null,'mcoffeefile'
          datasrcnr = yield Feel.qCacheFile file.path,null,'mcoffeefilenr'
          if datasrc && datasrcnr
            @newCoffee[filename] = datasrc
            @newCoffeenr[filename] = datasrcnr
            return
          try
            src = Feel.cacheCoffee file.path
          catch e
            console.error Exception e
            throw new Error "failed read coffee in module #{@name}: #{file.name}(#{file.path})",e
          @newCoffee[filename] = _regenerator src
          @newCoffeenr[filename] = src
          if _production
            @newCoffee[filename] = yield Feel.yjs @newCoffee[filename]
            #@newCoffeenr[filename] = yield Feel.yjs @newCoffeenr[filename]
          yield Feel.qCacheFile file.path,@newCoffee[filename],'mcoffeefile'
      if file.ext == 'js'
        do (filename,file)=> qs.push do Q.async =>
          src = ""
          datasrc = Feel.cacheFile file.path,null,'mcoffeefile'
          datasrcnr = Feel.cacheFile file.path,null,'mcoffeefilenr'
          if datasrc && datasrcnr
            @newCoffee[filename] = datasrc
            @newCoffeenr[filename] = datasrcnr
            return
          try
            src = fs.readFileSync file.path
          catch e
            console.error Exception e
            throw new Error "failed read js in module #{@name}: #{file.name}(#{file.path})",e
          @newCoffee[filename] = _regenerator src
          @newCoffeenr[filename] = src
          if _production
            @newCoffee[filename] = yield Feel.yjs @newCoffee[filename]
            #@newCoffeenr[filename] = yield Feel.yjs @newCoffeenr[filename]
          yield Feel.qCacheFile file.path,@newCoffee[filename],'mcoffeefile'
          yield Feel.qCacheFile file.path,@newCoffeenr[filename],'mcoffeefilenr'
    yield Q.all qs
    @coffee     = @newCoffee
    @coffeenr     = @newCoffeenr
    @allCoffee  = "(function(){ var arr = {}; (function(){"
    @allJs      = ""
    num = 0
    for name,src of @coffee
      m = name.match /^(.*)\.(coffee|js)/
      if m
        num++
        @allJs += "\n(function(){\n#{src}\n}).call(this);"
    @allCoffee += @allJs
    @allCoffee += "\n}).call(arr);return arr; })()"
    @allCoffee = "" unless num
    #if _production
    #  @allCoffee = yield Feel.yjs @allCoffee
    @setHash()
  jsfile : (fname)=>
    f = @coffee[fname]
    f ?= @coffee[fname+".coffee"]
    f ?= @coffee[fname+".js"]
    if f?.toString
      f = f.toString()
    return f
  jsfilet : (fname)=>
    f = @jsfile fname
    return f unless f
    #return f.replace /^\}\)\.call\(this\)\;$/mgi,"}).call(_FEEL_that);"
    return "(function(){\n"+f+"\n}).call(_FEEL_that);"
  jsNames : (fname)=> Object.keys @coffee
  makeJs  : =>
    @newJs = {}
    for filename, file of @files
      if file.ext == 'js'
        src = ""
        try
          src = fs.readFileSync file.path
        catch e
          console.error Exception e
          throw new Error "failed read js in module #{@name}: #{file.name}(#{file.path})",e
        @newJs[filename] = src
    @js     = @newJs
    @allJs  = "(function(){ var arr = {};"
    num = 0
    for name,src of @js
      m = name.match /^(.*)\.js/
      if m
        num++
        @allJs += "(function(){ \n#{src}\n }).call(arr);"
    @allJs += "return arr; })()"
    @allJs  = "" unless num
    #if _production
    #  return Feel.yjs(_regenerator @allJs)
    #  .then (js)=>
    #    @allJs = js
    #    @setHash()
    @allJs  = _regenerator @allJs
    @setHash()
    return Q()
  setHash : =>
    @jsHash     = @hash @allJs
    @coffeeHash = @hash @allCoffee
  hash : (f)=>
    sha1 = crypto.createHash 'sha1'
    sha1.setEncoding 'hex'
    sha1.update f
    sha1.digest('hex').substr 0,10

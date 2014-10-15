
fs = require 'fs'

class Static
  constructor : ->
    @files = {}
  init : =>
    
  handler : (req,res,site)=>
    m     = req.url.match /^\/file\/(\w+)\/([^\.].*)\.(\w+)$/
    return @res404 req,res unless m
    if m[2].match /\.\./
      return @res404 req,res unless m
    hash  = m[1]
    path  = "./www/#{site}/static/#{m[2]}.#{m[3]}"
    console.log 'GET ',path
    ext   = m[3]
    if @files[path]?
      return @write @files[path],req,res

    fs.readFile path, (err,data)=>
      if err?
        return @res404 req,res
      @files[path] =
        data : data
      return @write @files[path],req,res

  write   : (file,req,res)=>
    res.write file.data
    return res.end()
    
    
  F       : (site,file)=> "/file/666/#{file}"
  res404  : (req,res)=>
    res.writeHead 404
    res.end()

module.exports = Static




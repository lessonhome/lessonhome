http   = require 'http'

class module.exports
  constructor : ->
    @server = http.createServer @query
  run   : ->
    @server.listen 80, '127.0.0.1'
    console.log "Feel server running on http://127.0.0.1:8080/"
  stop  : ->
    console.log "server stoped"
  query : (req,res)=>
    res.writeHead 200, { "Content-type" : "text/plain" }
    res.end 'Hello World\n'
  

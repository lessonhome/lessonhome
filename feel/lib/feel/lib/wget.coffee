wget = require('wget')

global._wget = (protocol,host,url)->
  d = Q.defer()
  options =
    protocol: protocol
    host: host
    path: url
    method: 'GET'
  req = wget.request options, (res)->
    content = ''
    res.on 'error', (err)-> d.reject err
    res.on 'data', (chunk)-> content += chunk
    res.on 'end', -> d.resolve {data:content,statusCode:res.statusCode}
  req.on 'error', (err)-> d.reject err
  req.end()
  return d.promise

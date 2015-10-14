

class Direct
  constructor : ->
    $W @
  call : (method,data={})=>
    try
      return yield Q.ninvoke @yd,'post', 'json/v5/ads/',{
        method : method
        params : data
        client_id : '2764ed9d6b6e4b1d8a7441afa5eaec3b'
        client_secret : '7208b7c5f6b94e4fa5e03835cd5a6152'
      }
    catch e
      console.error e
      return {}
  init : =>
    @yd = require('request-json').createClient('https://api.direct.yandex.com/')
    @yd.headers['Authorization'] = 'Bearer 503e2b7df23442b9ba78765a38943f34'
    #@yd.headers['Client-Login'] = 'lessonhome'
    
    console.log (yield @call 'GetVersion').body
    
  

module.exports = Direct





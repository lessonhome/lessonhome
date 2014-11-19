
@route = "/test"

extend './template'
console.log @parent
@parent.content = module 'dev/urls' :
  urls : $urls.text


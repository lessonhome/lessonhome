
@route = "/test"

extend './template'

@parent.content = module 'dev/urls' :
  urls : $urls.text


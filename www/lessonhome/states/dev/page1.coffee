

class @main extends template './template'
  route : "/test"
  tree  : ->
    content : module 'dev/urls' :
      urls : $urls.text



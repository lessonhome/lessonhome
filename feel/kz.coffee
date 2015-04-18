
require('coffee-script/register')
require './lib/feel/lib'

fs    = require 'fs'
curl  = require 'curlrequest'

domen = "http://www.kartaznaniy.ru"
_curl = (url)=>
  d = Q.defer()
  curl.request url:domen+url, (err,data)=>
    return d.reject err if err?
    d.resolve data
  return d.promise


sections = {}


run = => Q.spawn =>
  src = yield _curl '/repetitory'
  m = src.match /<p><a href=\"(\/repetitory\/[^\"]+)\">([^<]+)</gmi
  for l in m
    m2 = l.match /<p><a href=\"(\/repetitory\/[^\"]+)\">([^<]+)</mi
    sections[m2[2]] = m2[1]
  for s of sections
    yield parseSection s

parseSection = (name)=> do Q.async =>
  src = yield _curl sections[name]
  console.log src.length


run()



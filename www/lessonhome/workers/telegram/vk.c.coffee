
_vk = require 'vksdk'

hteoken = "http://oauth.vkontakte.ru/authorize?client_id=5331682&scope=audio,offline&redirect_uri=http://api.vk.com/blank.html&display=page&response_type=token"

class Vk
  init  : =>
    @jobs = _Helper 'jobs/main'
    @vk = new _vk
      appId : '5331682'
      appSecret : 'mIWwXoo5jXKbbgGZa61d'
      language : 'ru'
    @vk.setSecureRequests true
    yield @setToken()
    @vk.setToken 'f602f28ade22139aa54cb4f5968493a6dd11b428c3a602f5e11b746c35d7c4c57f14cfa53c08045f3f6f6'
    
    yield @jobs.listen 'findAudio',@audio
  setToken : =>
    d = Q.defer()
    Q.spawn => d.resolve yield _waitFor @vk, 'serverTokenReady'
    @vk.requestServerToken()
    return d.promise
  solve : (foo,data={})=>
    d = Q.defer()
    @vk.request foo, data,(o)=>
      if o?.response?
        d.resolve o.response
      else
        d.reject o
    return d.promise
  audio : (name,count=1,offset=0)=>

    ret = yield @solve 'audio.search',
      q:name
      auto_complete : 1
      sort:2
      count:count
      offset:offset
    return ret.items ? []

module.exports = Vk




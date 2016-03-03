
_google = require 'google-images'

hteoken = "http://oauth.vkontakte.ru/authorize?client_id=5331682&scope=audio,offline&redirect_uri=http://api.vk.com/blank.html&display=page&response_type=token"
_key = 'AIzaSyBUSFJqRf-3yY35quvhW9LY3QLwj_G9d7A'
ids = '001121832886483258854:wqaphdjdq04'
_id = '222501408422-u7psm3l3s1ibblfcttins5826g0epbpb.apps.googleusercontent.com'
_id1 = '222501408422-7j9qer7h8909n5cfrtgud0mnpu00aafm.apps.googleusercontent.com'
_key1 = 'xc580KYV5Yma6LlKCRHY6u-l'
keys = 'AIzaSyB0jjEfV5O-HIXsVoUeySmmNny2roAgRqI'
class Google
  init  : =>
    @jobs = _Helper 'jobs/main'
    @google = _google ids,keys
    
    yield @jobs.listen 'findImage',@image
  
  
  image : (name,count=5,offset=0)=>
    images = yield @google.search name,
      num : count+offset
      size : 'large'
    images = images.splice offset,count
    urls = []
    images ?= []
    for img in images
      urls.push img.url
    return urls
module.exports = Google




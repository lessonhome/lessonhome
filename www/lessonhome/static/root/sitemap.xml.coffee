
_sitemap = require "sitemap"

main = [
  '/'
  '/tutors_search'
  '/tutors_lp'
  '/enter'
  '/tutor_registration'
  '/contacts'
]
other = []


class Sitemap
  init : =>
    @redis = yield _Helper('redis/main').get()
    @jobs = _Helper('jobs/main')
    @udata = yield Main.service 'urldata'
    urls = yield _invoke @redis,'get','sitemap'
    if urls
      @sitemap = _sitemap.createSitemap {
        hostname : 'https://lessonhome.ru'
        cacheTime: 600000
        urls : JSON.parse urls
      }
      Q.spawn =>
        #yield Q.delay 30*1000
        yield @generate()
    else
      yield @generate()
    Q.spawn =>
      while true
        yield Q.delay 15*60*1000
        yield @generate()

  handler : (req,res,site)->
    res.setHeader('Content-Type', 'application/xml; charset=utf-8')
    res.end @sitemap.toString()
  generate : =>
    console.log 'generateing sitemap'.grey
    urls = []
    @push urls,u for u in main
    states = yield @jobs.solve 'getAllStates'
    for key,val of states
      @push urls,key if val.match /reclame_jump_page_templates/
    filter = {
      data:_setKey (yield @udata.u2d('')),'mainFilter'
      hash : ''
    }
    indexes = yield @jobs.solve 'filterTutors',{filter}
    indexes = indexes.filters[''].indexes
    url = "/tutor_profile?"+yield @udata.d2u 'tutorProfile',{'index':637}
    for index in indexes
      @push urls,url.replace(637,index),0.8
    url = "/tutors_search?"+yield @udata.d2u 'tutorsFilter',{'offset':637}
    for ind,i in indexes by 10
      continue if i<10
      @push urls,url.replace(637,i),0.6
    @sitemap = _sitemap.createSitemap {
      hostname : 'https://lessonhome.ru'
      cacheTime: 600000
      urls : urls
    }

  push : (urls,url,priority=1,changefreq='daily')=>
    urls.push {url,changefreq,priority}



module.exports = Sitemap





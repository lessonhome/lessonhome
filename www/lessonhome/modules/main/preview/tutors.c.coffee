
filter = require './filter'

class Tutors
  constructor : ->
    Wrap @
    @timereload = 0
    @inited = 0
  init : =>
    return _waitFor @,'inited' if @inited == 1
    return if @inited > 1
    @inited = 1
    @urldata = yield Main.service 'urldata'
    @dbtutor = yield @$db.get 'tutor'
    @dbpersons = yield @$db.get 'persons'
    yield @reload()
    @inited = 2
    @emit 'inited'
    setInterval =>
      @reload().done()
    , 30*1000
  handler : ($,data)->
    yield @init()
    url = $.req.url.match(/\?(.*)$/)?[1] ? ""
    mf = (yield @urldata.u2d url)?.mainFilter
    return filter.filter @persons,mf
  reload : =>
    t = new Date().getTime()
    return @persons unless (t-@timereload)>(1000*10)
    @timereload = t
    tutor  =  _invoke @dbtutor.find({}),'toArray'#,{account:1,status:1,subjects:1,reason:1,slogan:1,about:1,experience:1,extra:1,settings:1,calendar:1,check_out_the_areas:1}), 'toArray'
    person = _invoke @dbpersons.find({hidden:{$ne:true}}),'toArray'#,{account:1,ava:1,first_name:1,middle_name:1,last_name:1,sex:1,birthday:1,location:1,interests:1,work:1,education:1}),'toArray'
    [tutor,person] = [(yield tutor),(yield person)]
    persons = {}
    for val in tutor
      continue unless val?.account
      persons[val.account] ?= {}
      persons[val.account].tutor = val
    for val in person
      continue unless val?.account
      continue unless persons[val.account]?
      persons[val.account].person = val
    for account,obj of persons
      t = obj.tutor
      p = obj.person
      obj.rating = JSON.stringify(obj).length*(obj?.person?.ratio ? 1.0)
      rmax = Math.max(rmax ? obj.rating,obj.rating)
      rmin = Math.min(rmin ? obj.rating,obj.rating)
      continue if (t?.subjects?[0]?.name) && (p?.first_name)
      delete persons[account]
    for account,o of persons
      t = o?.tutor
      p = o?.person
      obj = {}
      obj.rating = o.rating
      obj.account = account
      obj.name = {}
      obj.name.first = p?.first_name
      obj.name.last  = p?.last_name
      obj.name.middle = p?.middle_name
      obj.about = t?.about
      obj.subjects = {}
      obj.gender  = p.sex
      obj.place = {}
      for ind,val of t?.subjects
        ns = obj.subjects[val.name] = {}
        ns.description = val.description
        obj.about = ns.description unless obj.about
        ns.price  = {left: +val.price?.range?[0]}
        ns.price.right = +(val.price?.range?[1] ? ns.price.left)
        ns.duration  = {}
        d = val.price?.duration
        if d?.left?
          d = [d.left,d.right]
          d[1] ?= d[0]
        if (typeof d == 'string') && d
          o = d.match(/^\D*(\d*)?\D*(\d*)?/)
          d = []
          d.push o[1] if o[1]?
          d.push (o[2] ? o[1]) if (o[2] ? o[1])?
        unless (+d?[0]) > 1
          d = [60,120]
        unless (+d?[1]) > 1
          d[1] = d[0]+30
        ns.duration = {left:d[0],right:d[1]}
        def = 800
        ns.price.right = 900*3  unless ns.price.right > 0
        ns.price.left  = 600    unless ns.price.left > 0
        ns.duration.right = 180 unless ns.duration.right > 0
        ns.duration.left  = 90  unless ns.duration.left > 0
        l = ns.price.left*60/ns.duration.left
        r = ns.price.right*60/ns.duration.right
        ns.price_per_hour  = 0.5*(r+l)
        obj.price_left  = Math.round(Math.min(obj.price_left ? ns.price.left,ns.price.left)/50)*50
        obj.price_right = Math.round(Math.max(obj.price_right ? ns.price.right, ns.price.right)/50)*50
        obj.duration_left  = Math.round(Math.min(obj.duration_left ? ns.duration.left,ns.duration.left)/15)*15
        obj.duration_right = Math.round(Math.max(obj.duration_right ? ns.duration.right, ns.duration.right)/15)*15
        obj.price_per_hour = Math.round(ns.price_per_hour/50)*50
        for key,val of val?.place
          obj.place[val] = true
      obj.experience = t?.experience
      obj.status = t?.status
      obj.photos = []
      if p?.ava?[0]? then for ind,ph of p?.ava
        obj.photos.push {
          lwidth  : ph.lwidth
          lheight : ph.lheight
          lurl    : ph.lurl
          hheight : ph.hheight
          hwidth : ph.hwidth
          hurl    : ph.hurl
        }
      unless obj.photos.length
        obj.photos.push {
          lwidth  : 200
          lheight : 300
          lurl    : "/file/f1468c11ce/unknown.photo.gif"
          hheight : 300
          hwidth : 200
          hurl    : "/file/f1468c11ce/unknown.photo.gif"
        }
      obj.location = p.location
      persons[account] = obj
    rmin ?= 0
    rmax ?= 1
    if rmax <= rmin
      rmax = rmin + 1
    for acc,p of persons
      p.rating = (p.rating-rmin)/(rmax-rmin)
      p.rating *= 3
      p.rating += 2
    @persons = persons
    return @persons

tutors = new Tutors
module.exports = tutors



class Tutors
  constructor : ->
    Wrap @
    @timereload = 0
  init : ($)=>
    @inited = true
    @dbtutor = yield $.db.get 'tutor'
    @dbpersons = yield $.db.get 'persons'
  handler : ($,data)->
    yield @init($) unless @inited
    persons = yield @reload()
    return persons
  reload : =>
    t = new Date().getTime()
    return @persons unless (t-@timereload)>(1000*10)
    @timereload = t
    tutor  =  _invoke @dbtutor.find({},{account:1,status:1,subjects:1,reason:1,slogan:1,about:1,experience:1,extra:1,settings:1,calendar:1,check_out_the_areas:1}), 'toArray'
    person = _invoke @dbpersons.find({},{account:1,ava:1,first_name:1,middle_name:1,last_name:1,sex:1,birthday:1,location:1,interests:1,work:1,education:1}),'toArray'
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
      continue if (t?.subjects?[0]?.name) && (p?.ava?[0]?) && (p?.first_name)
      delete persons[account]
    for account,o of persons
      t = obj?.tutor
      p = obj?.person
      obj = {}
      obj.name = {}
      obj.name.first = p?.first_name
      obj.name.last  = p?.last_name
      obj.name.middle = p?.middle_name
      obj.about = t?.about
      obj.subjects = {}
      for ind,val of t.subjects
        ns = obj.subjects[val.name] = {}
        ns.description = val.description
        obj.about = ns.description unless obj.about
        ns.price  = {left: +val.price?.range?[0]}
        ns.price.right = +(val.price?.range?[1] ? ns.price.left)
        ns.duration  = {}
        ns.duration.right  = +val.price?.duration
        ns.duration.left   = +val.price?.duration
        def = 800
        ns.price.right = 900*3  unless ns.price.right > 0
        ns.price.left  = 600    unless ns.price.left > 0
        ns.duration.right = 180 unless ns.duration.right > 0
        ns.duration.left  = 90  unless ns.duration.left > 0
        ns.price_per_hour  = 0.5*((ns.price.right*60/ns.duration.right)+
                                 (ns.price.left*60/ns.duration.left))
        obj.price_per_hour ?= ns.price_per_hour
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
      obj.location = p.location
      persons[account] = obj
    @persons = persons
    return @persons

tutors = new Tutors
module.exports = tutors

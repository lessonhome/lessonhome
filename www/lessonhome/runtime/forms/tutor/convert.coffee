

status =
  student   : 'Студент'
  school_teacher : 'Преподаватель школы'
  university_teacher       : 'Преподаватель ВУЗа'
  private_teacher      : 'Частный преподаватель'
  native_speaker  : 'Носитель языка'

class @F2V
  $all_subjects : (data) ->
    if not data.subjects? then return false
    result = {}
    for key, subject of data.subjects
      result[key] = {
        name : subject.name
        course : subject.course
        pre_school : subject.tags["school:0"]
        junior_school : subject.tags["school:1"]
        medium_school : subject.tags["school:2"]
        high_school : subject.tags["school:3"]
        student : subject.tags.student
        adult : subject.tags.adult
        comments : subject.description
      }
      if subject.groups? and subject.groups[0].description isnt ''
        result[key]['group_learning'] = {
          selected : true
          groups : subject.groups[0].description
          price : subject.groups[0].price if subject.groups[0].price?
        }
      if subject.place?
        if subject.place_prices?
          for val in subject.place
            if (prices = subject.place_prices[val])?
              result[key]['place_'+ val] = {
                selected : true
                one_hour : prices[0]
                two_hour : prices[1]
                tree_hour : prices[2]
              }
        else
          prices = yield @hour_prices_new(subject)
          for val in subject.place
            result[key]['place_'+ val] = {
              selected : true
              one_hour: prices.v60
              two_hour: prices.v90
              tree_hour: prices.v120
            }
    return result
  $status       : (data)-> status[data?.status] ? ''
  $status2       : (data)-> status[data?.status]
  $settings_new_orders : (data)-> data?.settings?.new_orders
  $settings_get_notifications_sms : (data)->
    if data?.settings?.get_notifications?
      for key, val of data.settings.get_notifications
        if val == 'sms' then return true
      return false
    else
      return true
  $settings_get_notifications_email : (data)->
    if data?.settings?.get_notifications?
      for key, val of data.settings.get_notifications
        if val == 'email' then return true
      return false
    else
      return true
  $settings_call_operator_possibility : (data)-> data?.settings?.call_operator_possibility
  $phone_call_description : (data)-> data?.phone_call?.description
  $calendar : (data)-> data?.calendar || {}
  $subject  : (data)-> data?.subjects?[0]
  $isTag    : (data)->
    ret = {}
    tags = (yield @$subject(data))?.tags
    nt = {}
    if tags?[0]?
      for key,val of tags
        if typeof val == 'object'
          for k,v of val
            nt[v] = true
        else
          nt[val] = true
      tags = nt
    for key,val of tags
      ret[key] = if val then true else false
    return ret
    #ret = {}
    #tags = (yield @$subject(data))?.tags || []
    #for key,tag of tags
    #  ret[tag] = true
    #return ret
  $isPlace    : (data)->
    ret = {}
    tags = (yield @$subject(data))?.place || []
    for key,tag of tags
      ret[tag] = true
    return ret
  $srange   : (data)->
    r = (yield @$subject(data))?.price?.range
    ret =  {
      left : r?[0] || 500
      right : r?.pop?() || 1500
    }
    return ret
  $scourse : (data)->
    course = (yield @$subject(data))?.course
    tags   = (yield @$subject(data))?.tags
    unless course && typeof course == 'object'
      course = {}
      if typeof tags == 'string'
        o = {}
        o[tags] = 1.0
        tags = o
      return {} unless tags && (typeof tags=='object')
      set = 0
      for key,val of tags
        if (typeof val == 'number') && (+val > 0)
          course[set++] = key
      unless set>0
        if typeof tags[0] == 'string'
          course[set++] = tags[0]
    return course
      


  $sduration  : (data)->
    d = (yield @$subject(data))?.price?.duration
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
    d= {left:d[0],right:d[1]}
    return d
  $splace : (data)->
    places = {'tutor':'у репетитора', 'pupil':'у ученика', 'remote':'удалённо', other:'другое место'}
    ret = ''
    p = (yield @$subject(data))?.place
    if p?
      for key,val of p
        ret += places[val]+", "
      if ret.length
        ret = ret.substring(0, ret.length - 2)
    return ret

  $scategory_of_student : (data)->
    #categories_of_student = {'school:0':'дошкольники', 'school:1':'младшая школа', 'school:2':'средняя школа', 'school:3':'старшая школа', 'student':'студент', 'adult':'взрослый'}
    ret = ''
    tags = (yield @$subject(data))?.tags
    if tags? && tags
      for key,tag of tags
        switch tag
          when "school:0"
            ret += "дошкольники, "
          when "school:1"
            ret += "младшая школа, "
          when "school:2"
            ret += "средняя школа, "
          when 'school:3'
            ret += "старшая школа, "
          when 'student'
            ret += "студент, "
          when 'adult'
            ret += "взрослый, "

      if ret.length
        ret = ret.substring(0, ret.length - 2)

    return ret
  hour_prices_new : (subject) ->
    v60 = ''
    v90 = ''
    v120 = ''
    p1 = +subject.price?.range?[0]
    p2 = +subject.price?.range?[1]
    t1 = +subject.price?.duration?.left
    t2 = +subject.price?.duration?.right
    if p1 isnt NaN and p2 isnt NaN and t1 isnt NaN and t2 isnt NaN

      delta_t = t2 - t1
      if delta_t == 0 or ( ( k = (p2 - p1)/delta_t ) > 200 or k < 4) then k = 14
      v60  = k*(60 - t1)  + p1
      v90  = k*(90 - t1)  + p1
      v120 = k*(120 - t1) + p1

      v60 = yield @getPriceValue v60
      v90 = yield @getPriceValue v90
      v120 = yield @getPriceValue v120

    return {v60, v90, v120}
  getPriceValue: (val)=>
    val /= 50
    val = Math.round(val)
    val *= 50
    return val




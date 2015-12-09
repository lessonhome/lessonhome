

_subjects = Feel.const('filter').subjects
_course   = Feel.const('filter').course
_price    = Feel.const('filter').price
_status   = Feel.const('filter').status
_sex      = Feel.const('filter').sex


aToS = (obj={},arr)->
  arr ?= {}
  if arr.length then for a in arr
    arr[a] = true
  s = ''
  i = 0
  for key,o of obj
    for val in o
      if arr[val]
        delete arr[val]
        s += ',' if s
        s += i
      i++
  return s

sToA = (obj={},str='')->
  str = str || ''
  str = str.split ','
  str2 = {}
  for s in str
    str2[s] = true
  arr = []
  i = 0
  for key,o of obj
    for val in o
      if str2[i]
        arr.push val
      i++
  return arr


oToB = (all=[],selected={})->
  ret = 0
  i = 1
  for it in all
    if selected[it]
      ret += i
    i*=2
  return ret

bToO = (all=[],bool=0)->
  selected = {}
  i = 0
  while bool
    c = bool%2
    bool = bool//2
    selected[all[i]] = c==1
    i++
  return selected



aToI = (all=[],selected)=>
  all.indexOf(selected)
iToA = (all=[],i=0)=> all[i]





class @D2U
  $subjects : (obj)=>
    type : 'string'
    value : aToS _subjects,obj?.subjects
    default : ''
  $course : (obj)=>
    type : 'string'
    value : aToS {obj:_course},obj?.course
    default : ''
  $price : (obj)=>
    type : 'int'
    value : oToB _price,obj?.price
    default : 0
  $status : (obj)=>
    type : 'int'
    value : oToB _status,obj?.status
    default : 0
  $sex    : (obj)=>
    type : 'int'
    value : aToI _sex, obj?.sex
    default : 0


class @U2D
  $subjects : (obj)=> sToA _subjects,obj?.subjects
  $course   : (obj)=> sToA {obj:_course},obj?.course
  $price    : (obj)=> bToO _price,obj?.price
  $status   : (obj)=> bToO _status,obj?.status
  $sex      : (obj)=> iToA _sex,obj?.sex




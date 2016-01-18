
_filter = Feel.const('filter')
_metro = Feel.const('metro')

_subjects = _filter.subjects
_course   = _filter.course
_price    = _filter.price
_status   = _filter.status
_sex      = _filter.sex

_lines = _metro.lines


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

maToS = (metro_arr, lines = _lines) ->
  result = []
  exist = {}
  i = null
  if metro_arr?.length
    for s in metro_arr
      s = s.split ':'
      exist[s[0]]?=[]
      i = lines[s[0]]?.stations.indexOf(s[1])
      exist[s[0]].push(i) if i? and i >= 0
    for b, ids_st of exist
      ids_st = ids_st.join(',')
      result.push b + ',' + ids_st if ids_st
  return result.join('#')

sToMa = (str='', lines = _lines)->
  str = str.split '#'
  metro_arr = []

  if str.length
    for block in str
      block = block.split(',')

      if block.length >= 2 and (l = lines[block[0]])?
        for i in [1...block.length]

          if (i = l.stations[block[i]])?
            metro_arr.push "#{block[0]}:#{i}"

  return metro_arr

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
  ret = all.indexOf(selected)
  return 0 if ret<0
  return ret
iToA = (all=[],i=0)=>
  i = 0 unless i>=0
  all[i]



class @D2U
  $subjects : (obj)=>
    type : 'string'
    value : aToS _subjects,obj?.subjects
    default : ''
    tutorsFilter : true
  $course : (obj)=>
    type : 'string'
    value : aToS {obj:_course},obj?.course
    default : ''
    tutorsFitler : true
  $price : (obj)=>
    type : 'int'
    value : oToB _price,obj?.price
    default : 0
    tutorsFilter : true
  $status : (obj)=>
    type : 'int'
    value : oToB _status,obj?.status
    default : 0
    tutorsFilter : true
  $sex    : (obj)=>
    type : 'int'
    value : aToI _sex, obj?.sex
    default : 0
    tutorsFilter : true
  $metro : (obj)=>
    type: 'string'
    default : ''
    value : maToS obj?.metro
    tutorsFilter : true


class @U2D
  $subjects : (obj)=> sToA _subjects,obj?.subjects
  $course   : (obj)=> sToA {obj:_course},obj?.course
  $price    : (obj)=> bToO _price,obj?.price
  $status   : (obj)=> bToO _status,obj?.status
  $sex      : (obj)=> iToA _sex,obj?.sex
  $metro    : (obj)=> sToMa obj?.metro




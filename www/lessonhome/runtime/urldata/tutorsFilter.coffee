

_subjects = @const('../../const/subjects').subjects


aToI = (obj,arr)->
  arr ?= {}
  if arr.length then for a in arr
    arr[a] = true
  s = ''
  i = 0
  for key,o of obj
    for val in o
      if arr[val]
        s += ',' if s
        s += i
      i++
  return s

iToA = (obj,str)->
  str = str || ''
  str = str.split ','
  for s in str
    str[s] = true
  arr = []
  i = 0
  for key,o of obj
    for val in o
      if str[i]
        arr.push val
      i++
  return arr

  
  





class @D2U
  $subjects : (obj)=>
    type : 'string'
    value : aToI _subjects,obj?.subjects
    default : ''

class @U2D
  $subjects : (obj)=> iToA _subjects,obj?.subjects



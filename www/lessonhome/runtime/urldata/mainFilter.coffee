
tutor_status_text =
  student : 'Cтудент'
  school_teacher : 'Преподаватель школы'
  university_teacher : 'Преподаватель ВУЗа'
  private_teacher  :'Частный преподаватель'
  native_speaker : 'Носитель языка'
group_lessons = ['не проводятся','2-4 ученика','до 8 учеников','от 10 учеников']
sort          = ['rating','price','experience','way_time','-price','-experience','-rating','-way_time','register','-register','access','-access']
gender = ['','male','female','mf']
tutor_status = 'student,school_teacher,university_teacher,private_teacher,native_speaker'.split ','
place = 'pupil,tutor,remote'.split ','
experience = 'little_experience,big_experience,bigger_experience'.split ','

numstr = {}
_numstr = {}
for c,i in 'opqmschjtui'
  _numstr[c] = i
_numstr['i'] = '.'
for c,i in 'opqmschjtui'
  numstr[i] = c
numstr['.'] = numstr[10]
boolSet = (obj,list)=>
  list.sort()
  v = 0
  i = 1
  for s in list
    v+= i if obj?[s]
    i*=2
  return v
boolSetR = (obj,list)=>
  list.sort()
  ret = {}
  v = obj ? 0
  for s in list
    ret[s] = ((v%2)==1)
    v //= 2
  return ret

class @D2U
  $test : (obj)=>
    type  : 'int'
    value : obj?.test
    default : 0
  $linked : (obj)=>
    str = Object.keys(obj?.linked ? {})?.join?('.') ? ''
    str2 = ''
    for c,i in str
      str2 += numstr[c]
    str = str2
    return {
      type : 'string'
      value : str
      default : ''
      cookie : true
    }
  $priceLeft : (obj)=>
    type  : 'int'
    value : obj?.price?.left
    default : 500
    filter : true
  $priceRight : (obj)=>
    type  : 'int'
    value : obj?.price?.right
    default : 3500
    filter : true
  $gender : (obj)=>
    i = gender.indexOf(obj?.gender)
    i = undefined unless i >= 0
    return {
      type  : 'int'
      value : i
      default : 0
      filter : true
    }
  $with_reviews : (obj)=>
    type  : 'bool'
    value : obj?.with_reviews
    default : true
    filter : true
  $with_verification : (obj)=>
    type  : 'bool'
    value : obj?.with_verification
    default : false
    filter : true
  $tutor_status : (obj)=>
    type : 'int'
    value : boolSet obj?.tutor_status,tutor_status
    default : 0
    filter : true
  $place : (obj)=>
    type : 'int'
    value : boolSet obj?.place,place
    default : 0
    filter : true
  $placeArea : (obj)=>
    type : 'string[]'
    value : obj?.place?.area
    default : ''
    filter : true
  $subject : (obj)=>
    type : 'string[]'
    value : obj?.subject
    default : ''
    filter : true
  $time_spend_way : (obj)=>
    type : 'int'
    value : obj?.time_spend_way
    default : 120
    filter : true
  $experience : (obj)=>
    type : 'int'
    value :  boolSet obj?.experience,experience
    default : 0
    filter : true
  $group_lessons : (obj)=>
    v = group_lessons.indexOf(obj?.group_lessons)
    v = 0 unless v>=0
    return {
      type : 'int'
      value : v
      default : 0
      filter : true
    }
  $course : (obj)=>
    type : 'string[]'
    value : obj?.course
    default : ''
    filter : true
  $sort : (obj)=>
    v = sort.indexOf(obj?.sort)
    v = 0 unless v >= 0
    return {
      type : 'int'
      value : v
      default : 0
      filter : true
      cookie : true
    }
  $showBy : (obj)=>
    type : 'bool'
    value : obj?.showBy == 'list'
    default : true
    cookie : true
  
class @U2D
  $test : (obj)=> obj?.test
  $linked : (obj)=>
    str = obj?.linked ? ''
    str2 = ''
    for c,i in str
      str2 += _numstr[c]
    str = str2
    arr = {}
    str = str.split '.'
    for a in str
      arr[+a]= true if (+a)>0
    return arr
  $price : (obj)=>
    left  : obj?.priceLeft
    right : obj?.priceRight
  $gender : (obj)=> gender[obj?.gender ? 0]
  $with_reviews : (obj)=> obj?.with_reviews
  $with_verification : (obj)=> obj?.with_verification
  $tutor_status : (obj)=> boolSetR obj?.tutor_status,tutor_status
  $tutor_status_text : (obj)=>
    arr = boolSetR obj?.tutor_status,tutor_status
    arr2 = []
    for key,val of arr
      arr2.push tutor_status_text[key] if val
    if arr2.length <= 0
      return 'Статус репетитора'
    arr2.sort (a,b)=>a.length>b.length
    ret = arr2.join(', ')
    if ret.length > 20
      ret = ret.substr(0,20)+"..."
    return ret
  $place : (obj)=>
    ret = boolSetR obj?.place,place
    ret.area = obj?.placeArea
    return ret
  $subject : (obj)=> obj?.subject
  $time_spend_way : (obj)=> obj?.time_spend_way
  $experience : (obj)=> boolSetR obj?.experience,experience
  $group_lessons : (obj)=> group_lessons[obj?.group_lessons ? 0]
  $sort : (obj)=> sort[obj?.sort ? 0]
  $showBy : (obj)=> if obj?.showBy==true then 'list' else 'grid'
  $course : (obj)=> obj?.course
  
  



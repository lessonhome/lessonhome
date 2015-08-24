
calendar = []
for i in [1..7] then for j in [1..3] then calendar.push ''+i+j

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

status = ['student','school_teacher','high_school_teacher','native_speaker']


class @D2U
  $name : (obj)=>
    type : 'string'
    default : ''
    value : obj?.name
    cookie : true
  $phone : (obj)=>
    type : 'string'
    default : ''
    value : obj?.phone
    cookie : true
  $phone_comment : (obj)=>
    type : 'string'
    default : ''
    value : obj?.phone_comment
    cookie : true
  $email : (obj)=>
    type : 'string'
    default : ''
    value : obj?.email
    cookie : true
  $subject : (obj)=>
    type : 'string'
    default : ''
    value : obj?.subject
    cookie : true
  $subject_comment : (obj)=>
    type : 'string'
    default : ''
    value : obj?.subject_comment
    cookie : true
  $calendar : (obj)=>
    type : 'int'
    default : 0
    value : boolSet obj?.calendar,calendar
    cookie : true
  $duration_left : (obj)=>
    type : 'int'
    default : 30
    value : obj?.duration?.left
    cookie : true
  $duration_right : (obj)=>
    type : 'int'
    default : 240
    value : obj?.duration?.right
    cookie : true
  $price_left : (obj)=>
    type : 'int'
    default : 400
    value : obj?.price?.left
    cookie : true
  $price_right : (obj)=>
    type : 'int'
    default : 5000
    value : obj?.price?.right
    cookie : true
  $status : (obj)=>
    type : 'int'
    default : 0
    value : boolSet obj?.status,status
    cookie : true
  $experience : (obj)=>
    type : 'string'
    default : 'неважно'
    value : obj?.experience
    cookie : true
  $gender : (obj)=>
    type : 'string'
    default : 'неважно'
    value : obj?.gender
    cookie : true
class @U2D
  $name : (obj)=> obj?.name
  $phone : (obj)=> obj?.phone
  $phone_comment : (obj)=> obj?.phone_comment
  $email : (obj)=> obj?.email
  $subject : (obj)=> obj?.subject
  $subject_comment : (obj)=> obj?.subject_comment
  $calendar : (obj)=> boolSetR obj?.calendar,calendar
  $duration : (obj)=>
    left : obj?.duration_left
    right : obj?.duration_right
  $price : (obj)=>
    left : obj?.price_left
    right : obj?.price_right
  $status : (obj)=> boolSetR obj?.status,status
  $experience : (obj)=> obj?.experience
  $gender : (obj)=> obj?.gender


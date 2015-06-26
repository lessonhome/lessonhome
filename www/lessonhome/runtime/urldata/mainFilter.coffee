

gender = ['','male','female','mf']



class @D2U
  $priceLeft : (obj)=>
    type  : 'int'
    value : obj?.price?.left
    default : 500
  $priceRight : (obj)=>
    type  : 'int'
    value : obj?.price?.right
    default : 1500
  $gender : (obj)=>
    i = gender.indexOf(obj?.gender)
    i = undefined unless i >= 0
    return {
      type  : 'int'
      value : i
      default : 0
    }
  $with_reviews : (obj)=>
    type  : 'bool'
    value : obj?.with_reviews
    default : false
  $with_verification : (obj)=>
    type  : 'bool'
    value : obj?.with_verification
    default : false

class @U2D
  $price : (obj)=>
    left  : obj?.priceLeft
    right : obj?.priceRight
  $gender : (obj)=> gender[obj?.gender]
  $with_reviews : (obj)=> obj?.with_reviews
  $with_verification : (obj)=> obj?.with_verification





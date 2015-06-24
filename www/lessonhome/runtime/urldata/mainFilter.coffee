

gender = ['male','female']



class @D2U
  $priceLeft : (obj)=>
    type  : 'int'
    value : obj?.price?.left
  $priceRight : (obj)=>
    type  : 'int'
    value : obj?.price?.right
  $gender : (obj)=>
    i = gender.indexOf(obj?.gender)
    i = undefined unless i >= 0
    return {
      type  : 'int'
      value : i
    }
  $with_reviews : (obj)=>
    type  : 'bool'
    value : obj?.with_reviews
  $with_verification : (obj)=>
    type  : 'bool'
    value : obj?.with_verification

class @U2D
  $price : (obj)=>
    left  : obj?.priceLeft
    right : obj?.priceRight
  $gender : (obj)=> gender[obj?.gender]
  $with_reviews : (obj)=> obj?.with_reviews
  $with_verification : (obj)=> obj?.with_verification





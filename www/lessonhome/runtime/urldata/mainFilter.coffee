




class @D2U
  $priceLeft : (obj)=>
    type  : 'int'
    value : obj?.price?.left
  $priceRight : (obj)=>
    type  : 'int'
    value : obj?.price?.right
  $price  : (obj)=>
    type : 'obj'
    value : obj?.price


class @U2D
  $price : (obj)=>
    left  : obj?.priceLeft
    right : obj?.priceRight











class @D2U
  $priceLeft : (obj)=>
    type  : 'int'
    value : obj?.price?.left
  $priceRight : (obj)=>
    type  : 'int'
    value : obj?.price?.right


class @U2D
  $price : (obj)=>
    left  : obj?.priceLeft
    right : obj?.priceRight






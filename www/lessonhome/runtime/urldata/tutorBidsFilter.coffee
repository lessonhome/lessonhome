


class @D2U
  $priceLeft : (obj)->
    type : 'int'
    value : obj?.price?.left
  $obj : (obj)->
    type : 'obj'
    value : obj
class @U2D
  $price : (obj)->
    left  : obj?.priceLeft
    right : obj?.priceRight
  $obj : (obj)-> obj.obj




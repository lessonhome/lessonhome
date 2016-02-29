
class @D2U
  $index : (obj)=>
    type : 'string'
    default : ''
    value : obj?.index

  $page : (obj)=>
    type : 'int'
    default : 0
    value : obj?.page

class @U2D
  $index : (obj)=> obj?.index
  $page : (obj)=> obj?.page


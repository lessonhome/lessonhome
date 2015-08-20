

class @D2U
  $index : (obj)=>
    type : 'int'
    default : 0
    value : obj?.index
  $inset : (obj)=>
    type : 'int'
    default : 0
    value : obj?.inset

class @U2D
  $index : (obj)=> obj?.index
  $inset : (obj)=> obj?.inset


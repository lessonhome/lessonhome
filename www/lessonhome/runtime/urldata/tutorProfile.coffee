

class @D2U
  $index : (obj)=>
    type : 'int'
    default : 0
    value : obj?.index
  $inset : (obj)=>
    type : 'int'
    default : 0
    value : obj?.inset
  $subject : (obj)=>
    type : 'string'
    default : ''
    value : obj?.subject

class @U2D
  $index : (obj)=> obj?.index
  $inset : (obj)=> obj?.inset
  $subject : (obj)=> obj?.subject


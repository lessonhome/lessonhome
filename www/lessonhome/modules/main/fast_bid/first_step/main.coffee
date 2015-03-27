
class @main
  show : =>
    @name = @tree.name.class
    @phone = @tree.phone.class
    @name.on 'change', @sendName
    @phone.on 'change', @sendPhone
  sendName : (val)=>
    @$send 'saveForm', 'fast_bid',{name:val}
    .then (msg)->
      console.log 'saved',msg
  sendPhone : (val)=>
    @$send 'saveForm', 'fast_bid',{phone:val}
    .then (msg)->
      console.log 'saved', msg

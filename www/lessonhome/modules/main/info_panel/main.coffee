

class @main
  dom : ->
    @dom.find('.js-button').click @onClick
  onClick : (e)=>
    console.log e

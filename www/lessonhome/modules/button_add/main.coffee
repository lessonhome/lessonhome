
class @main extends EE
  show : =>
    @dom.on 'click', @click




  click : =>
    @emit 'add_time'
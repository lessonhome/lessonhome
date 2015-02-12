
class @main extends EE
  show : =>
    @advanced_search = @dom.find ".js-button"
    @advanced_search.on 'click', => @send



  send : =>
    @emit 'advanced_search_open'
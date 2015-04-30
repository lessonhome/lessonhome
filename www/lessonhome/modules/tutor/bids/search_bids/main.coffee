class @main extends EE
  show : =>
    Feel.FirstBidBorderRadius(@dom)


    @advanced_search = @dom.find '.advanced_search'
    @advanced_filter = @advanced_search.children().first()


    @advanced_search.on 'click', @toggleFilter








  toggleFilter : =>
    @advanced_filter.toggle



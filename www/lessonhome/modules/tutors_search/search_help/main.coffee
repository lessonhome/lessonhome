class @main
  constructor : ->
    $W @
  Dom : =>
    @blockSearchHelp = @found.block_search_help
    @filterBlock = @found.filter_block
    @found.demo_modal?.on? 'click', => Q.spawn =>
      #передать параметр 'fullBid' для открытия полной формы
      yield Feel.jobs.solve 'openBidPopup'
  show: =>
    beforeFilter = @dom.parent().find('.search-filter')
    top_offset = beforeFilter.offset().top + beforeFilter.outerHeight()

    @blockSearchHelp.pushpin(
      {
        top: top_offset
        offset: 60
      }
    )

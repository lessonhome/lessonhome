class @main
  constructor : ->
    $W @
  Dom : =>
    @blockSearchHelp = @found.block_search_help
    @filterBlock = @found.filter_block
    @beforeFilter = @dom.parent().find('.search-filter')
    @found.demo_modal?.on? 'click', => Q.spawn =>
      #передать параметр 'fullBid' для открытия полной формы
      yield Feel.jobs.solve 'openBidPopup', null, 'filter_help'

    @showHelpPanel()

    $(window).on 'scroll', @showHelpPanel
  show: =>
    

  showHelpPanel: =>
    @top_offset = @beforeFilter.offset().top + @beforeFilter.outerHeight()

    if $(document).scrollTop() >= @top_offset
      setTimeout(@pushpinIit, 4000)

  pushpinIit: =>
    @blockSearchHelp.pushpin(
      {
        top: @top_offset
        offset: 60
      }
    )


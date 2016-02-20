class @main
  constructor : ->
    $W @
  Dom : =>
    @loadflag = 0
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

    if $(document).scrollTop() > @top_offset
      if @loadflag == 0
        setTimeout(@pushpinIit, 4000)
      else
        @pushpinIit()

  pushpinIit: () =>
    @top_offset = @beforeFilter.offset().top + @beforeFilter.outerHeight()

    @blockSearchHelp.pushpin(
      {
        top: @top_offset
        offset: 60
      }
    )
    @loadflag = 1

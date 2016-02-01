

class @main
  constructor : ->
    $W @
  Dom : =>
    @menuButton = @found.show_menu
    @fixedMenu  = @found.fixed_nav
    @offset_block = @found.offset_block
  show: =>
    top_offset = $(@offset_block).offset().top + $(@offset_block).outerHeight()
    @menuButton.sideNav()
    @fixedMenu.pushpin(
      {
        top: top_offset
      }
    )
    #@found.attach?.on? 'click', -> Feel.root.tree.class.attached.showForm()
    
    @found.demo_modal?.on? 'click', => Q.spawn =>
      #передать параметр 'fullBid' для открытия полной формы
      yield Feel.jobs.solve 'openBidPopup'
class @main
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

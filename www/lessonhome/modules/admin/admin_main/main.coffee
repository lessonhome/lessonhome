
class @main
  show: =>
    @window = $ window
    @ask_table = @found.ask_table
    @moderation_table = @found.moderation_table
    @moderation_filter = @dom.find "#moderation_filter_block"
    @ask_filter = @dom.find "#ask_filter_block"
    @currHeight = 0

    @setCurrHeight @ask_table
    @setCurrHeight @moderation_table

    @dom.find "#expand_moderation"
    .on "click", (e)=>
      @toggle e, @moderation_filter, @moderation_table

    @dom.find "#expand_ask"
    .on "click", (e)=>
      @toggle e, @ask_filter, @ask_table

    @window.resize =>
      @setCurrHeight @ask_table
      @setCurrHeight @moderation_table

  toggle : (e, elem, table) =>
    btn = $ e.currentTarget
    h_elem = elem.outerHeight(true)
    if btn.is '.active'
      btn.removeClass 'active'
      if elem.is ':visible'
        elem.slideUp 200, =>
          btn.find('i').text 'expand_more'
          @setCurrHeight table
          btn.addClass 'active'
      else
        table.height table.height() - h_elem
        elem.slideDown 200, ->
          btn.find('i').text 'expand_less'
          btn.addClass 'active'


  setCurrHeight : (elem) =>
    elem.height @window.height() - elem.offset().top + elem.height() - elem.outerHeight(true)

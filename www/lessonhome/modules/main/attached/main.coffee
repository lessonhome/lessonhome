


class @main
  Dom : =>
    @html = $('html')
    @panel = @tree.bottom_bar.class
    @panel_block = @found.bottom_bar
    @popup_block = @found.content
    @form_block = @found.popup
    @scrollWidth = @getScrollWidth()
  show : =>
    @updatePanel()
    Feel.urlData.on 'change', @updatePanel
    @panel.tree.button_attach.class.dom.on 'click', @showForm
    @form_block.on 'click', (e) => e.stopPropagation()
    @popup_block.on 'click', @hideForm
  showForm : =>
    @html.css {
        overflowY : 'hidden'
        marginRight: @scrollWidth
    }
    @popup_block.addClass 'fixed'
    return false
  hideForm : =>
    @html.css {
      overflowY : 'visible'
      marginRight: 0
    }
    @popup_block.removeClass 'fixed'

  updatePanel : => do Q.async =>
    length = yield @panel.reshow()
    if length != 0
      @panel_block.fadeIn()
    else
      @panel_block.fadeOut()
  getScrollWidth : =>
    div = $('<div>').css {
      position : 'absolute'
      top: '0px'
      left: '0px'
      width: '100px'
      height: '100px'
      visibility: 'hidden'
      overflow: 'scroll'
    }
    @html.find('body:first').append div
    width = div.get(0).offsetWidth - div.get(0).clientWidth
    div.remove()
    return width

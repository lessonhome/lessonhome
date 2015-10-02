


class @main
  Dom : =>
    @html = $('html')
    @bar = @tree.bottom_bar.class
    @bar_block = @found.bottom_bar

    @popup = @tree.popup.class
    @popup_block = @found.content

    @steps = {
      first : @popup.tree.first.class
      second : @popup.tree.second.class
      third : @popup.tree.third.class
    }

    @form_block = @found.popup
    @btn_send = @tree.popup.class.tree.btn_send.class
    @scrollWidth = @getScrollWidth()
  show : =>
    @updatePanel()
    Feel.urlData.on 'change', @updatePanel
    @bar.tree.button_attach.class.dom.on 'click', @showForm
    @form_block.on 'click', (e) => e.stopPropagation()
    @popup_block.on 'click', @hideForm
    @btn_send.dom.on 'click', @sendForm

  scrollToTop : =>
    @popup_block.addClass('fixed').animate {
      scrollTop : 0
    }, 300
  sendForm : => do Q.async =>
    data = yield Feel.urlData.get 'pupil'
    data.linked = yield Feel.urlData.get 'mainFilter','linked'
    error = @js.check data

    if error.correct is false
      @scrollToTop()
      @popup.parseError error
    if !error['phone']?
      {status,errs} = yield @$send('./save', data)
      if status is 'failed'
        @popup.parseError errs
        return false
      else if error.correct is true
        @endAttach()
        return true

  endAttach : => do Q.async =>
    yield Feel.urlData.set 'mainFilter','linked', {}
    @hideForm()

  showForm : =>
    @popup_block.show('slow')
    @html.css {
        overflowY : 'hidden'
        marginRight: @scrollWidth
    }
    @popup_block.addClass('fixed')
    @scrollToTop()
    return false
  hideForm : =>
    @html.css {
      overflowY : 'visible'
      marginRight: 0
    }
    @popup_block.removeClass 'fixed'

  updatePanel : => do Q.async =>
    length = yield @bar.reshow()
    if length != 0
      @bar_block.fadeIn()
    else
      @bar_block.fadeOut()
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

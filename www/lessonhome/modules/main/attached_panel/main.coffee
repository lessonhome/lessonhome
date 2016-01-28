class @main
  constructor: ->
    $W @
  Dom : =>
    @html = $('html')
    @bar = @tree.bottom_bar.class
    @bar_block = @found.bottom_bar

    @popup = @tree.popup.class
    @popup_block = @found.content

    @form_block = @found.popup
    @btn_send = @tree.popup.class.tree.btn_send.class
    @scrollWidth = yield @getScrollWidth()

  show : =>
    @register 'bid_attached'
    @updatePanel()
    Feel.urlData.on 'change', @updatePanel
#    @tree.bottom_bar.class.found.btn_attach.click @showForm
    @form_block.on 'click', (e) => e.stopPropagation()
    @popup_block.on 'click', @hideForm
    @tree.popup.class.on 'close', @hideForm
    @btn_send.on 'submit', => Q.spawn =>
      errors = yield @sendForm()
      if errors.correct
        yield Feel.urlData.set 'mainFilter','linked':{}
        Feel.sendGActionOnceIf(18000,'bid_full','form_submit')
        Feel.go '/fast_bid/fourth_step'
      else
        @popup.parseError errors
        @scrollToTop()

    @tree.popup.first.phone.class.on 'end', => Q.spawn =>
      errors = yield @sendForm()
      unless errors.correct then @popup.parseError phone : errors['phone']
  scrollToTop : =>
    @popup_block.addClass('fixed').animate {
      scrollTop : 0
    }, 300

  sendForm : (quiet='quiet')=>
    data = yield Feel.urlData.get 'pupil'
    data.linked = yield Feel.urlData.get 'mainFilter','linked'
    data.place = yield Feel.urlData.get 'mainFilter','place_attach'
    data = @js.takeData data
    error = @js.check data
    Feel.sendAction 'error_on_page' unless error.correct

    if !error['phone']?
      {status,errs, err} = yield Feel.jobs.server 'saveBid', data

      if err
        Feel.sendAction 'error_on_page'
        return {other: err }

      if status is 'success'
        Feel.sendActionOnce 'bid_popup'
      else
        Feel.sendAction 'error_on_page'
        error = errs

    return error
  showForm : =>
    @popup_block.show('slow')
    @html.css {
        overflowY : 'hidden'
        marginRight: @scrollWidth
    }
    @popup_block.addClass('fixed')
    @bar.btn_attach.fadeOut 300
    @scrollToTop()
    return false

  hideForm : =>
    @html.css {
      overflowY : 'visible'
      marginRight: 0
    }
    @bar.btn_attach.fadeIn 200
    @popup_block.removeClass 'fixed'

  updatePanel : =>
    length = yield @bar.reshow()
    return unless length?
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

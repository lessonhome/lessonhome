class @main
  Dom: =>
    @panel = @found.panel

    @title = @tree.title_element.class
    @form = @tree.content_form.class

    @btn_expand = @found.expand
    @container = @found.container
    @text_restore = @found.text_restore


  show : =>

#    @title.on? 'blur', @onBlurTitle
    @found.preremove.on 'click', @onPreremove
    @found.rem.on       'click', @onRemove
    @found.restore.on   'click', @onRestore
    @btn_expand.on      'click', @onExpand


#  onBlurTitle : => @slideDown()

  onPreremove : (e) =>
    e.stopPropagation()
    @event 'preremove'
    @slideUp => @panel.addClass 'restore'

  onRemove : (e) =>
    e.stopPropagation()
    @found.preremove.off 'click', @onPreremove
    @found.rem.off       'click', @onRemove
    @found.restore.off   'click', @onRestore
    @btn_expand.off      'click', @onExpand
    @event 'remove'
    @dom.parent().slideUp 300, -> $(@).remove()

  onRestore : => @panel.removeClass 'restore'

  event : (message) => @emit 'event', message

  onExpand: (e) =>
    e.stopPropagation()
    if @container.is ':visible'
      @slideUp()
    else
      @slideDown()
    return false


  slideUp :(callback) =>
    @container.slideUp 500, (e) =>
      @btn_expand.removeClass 'active'
      callback? e
  slideDown :(callback) =>
    @container.slideDown 500, (e) =>
      @btn_expand.addClass 'active'
      callback? e

  showForm : =>
    @container.show()
    @btn_expand.addClass 'active'

  hideForm : =>
    @container.hide()
    @btn_expand.removeClass 'active'

  reset : =>
    @onRestore()
#    @hideForm()
    @title?.setValue?()
    @form?.setValue?()
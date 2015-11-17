class @main
  Dom: =>
    @panel = @found.panel

    @title = @tree.title_element.class
    @form = @tree.content_form.class

    @btn_expand = @found.expand
    @container = @found.container
    @text_restore = @found.text_restore

    @observer = null
  show : =>
    @title?.setObserver? @
    @form?.setObserver? @

    @found.preremove.on 'click', @onPreremove
    @found.rem.on       'click', @onRemove
    @found.restore.on   'click', @onRestore
    @btn_expand.on      'click', @onExpand

  onPreremove : (e) =>
    e.stopPropagation()
    @slideUp =>
      @notifyObserver 'pre'
      @panel.addClass 'restore'

  handleEvent : (observable, message) => @observer?.handleEvent? @, message

  onRemove : (e) =>
    e.stopPropagation()
    @found.preremove.off 'click', @onPreremove
    @found.rem.off       'click', @onRemove
    @found.restore.off   'click', @onRestore
    @btn_expand.off      'click', @onExpand
    @notifyObserver 'rem'
    @dom.parent().slideUp 300, -> $(@).remove()

  onRestore : => @panel.removeClass 'restore'

  onExpand: (e) =>
    e.stopPropagation()
    if @container.is ':visible'
      @slideUp()
    else
      @slideDown()
    return false

  notifyObserver : (message) => @observer?.handleEvent? @, message
  setObserver : (observer) => @observer = observer

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

  copyValue: =>

  reset : =>
    @onRestore()
#    @hideForm()
    @title?.setValue?()
    @form?.setValue?()
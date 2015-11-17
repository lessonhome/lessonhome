class @main
  Dom : =>
    @container = @found.container
    @element = @tree.element.class
    @elements = []

    @observer = null
  show : =>
    @push @element
    @tree.add_button.class.on 'submit', @onAdd
    $('html').on 'click', => for e in @elements then e.onRestore()

  push : (element) =>
    element.setObserver @
    element.flag = false
    @elements.push element

  add : (element, is_open = false) =>
    element.reset()
    if is_open then element.showForm() else element.hideForm()
    block = $('<div class="block" style="display: none">').append element.dom
    @container.append block
    return block

  onAdd : =>
    elem = @element.$clone()
    @push elem
    @add(elem, true).slideDown 400

  setObserver : (observer) => @observer = observer

  handleEvent : (observable, message) =>
    @observer?.handleEvent? observable, message
    switch message
      when 'rem'
        @elements.splice @getIndex(observable), 1
#        observable.dom.closest('.block').slideUp 200, -> $(@).remove()
#      when 'focus'
#        observable.setNames @getNames()
#      when 'copy'
#        i = @getIndex observable
#        if i > 0 then observable.copySettings @subjects[i - 1], @copied_settings

  getForEach : (func) =>
    return null if func not instanceof Function
    result = {}
    result[i] = func.call(e) for e, i in @elements
    return result

  getIndex : (elem)  =>
    elem.flag = true
    for _elem, i in @elements
      if _elem.flag is true
        _elem.flag = false
        if elem.flag is false then break
    if elem.flag is true
      elem.flag = false
      return -1
    return i

class @main
  Dom : =>
    @container = @found.container

    @err_empty = @found.error_empty

    @element = @tree.element.class
    @elements = []
  show : =>
    @push @element

    @on 'remove', (elem) =>
      @elements.splice( i = @getIndex(elem), 1)
      @emit('rem_first') if i == 0
    @tree.add_button.class.on 'submit', @onAdd

  push : (element) =>
    element.on 'event', (message) => @emit message, element
    element.flag = false
    @elements.push element
    @emit 'pushed', element

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

  onAdd : =>
    @eachElem -> @slideUp?()
    @add().slideDown 500
    return false

  add : (data) =>
    element = @element.$clone()
    element.reset()

    if not data?
      element.showForm?()
    else
      element.setValue data
      element.hideForm?()

    @push element
    block = $('<div class="block" style="display: none">').append element.dom
    @container.append block
    return block

  eachElem : (func) => func.call(e, i) for e, i in @elements

  showErrEmpty : (error_text) => @err_empty.text(error_text).show()
  hideErrEmpty : => @err_empty.hide()


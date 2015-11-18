class @main
  Dom : =>
    @container = @found.container

    @element = @tree.element.class
    @elements = []

  show : =>
    @push @element
    @on 'remove', (elem) => @elements.splice @getIndex(elem), 1
    @tree.add_button.class.on 'submit', @onAdd

  push : (element) =>
    element.on 'event', (message) => @emit message, element
    @emit 'add', element
    element.flag = false
    @elements.push element

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
    @add().slideDown 500
    return false

  add : (data) =>
    element = @element.$clone()
    element.reset()

    if not data?
      element.showForm()
    else
      element.setValue data
      element.hideForm()

    @push element
    block = $('<div class="block" style="display: none">').append element.dom
    @container.append block
    return block

  eachElem : (func) => func.call(e, i) for e, i in @elements


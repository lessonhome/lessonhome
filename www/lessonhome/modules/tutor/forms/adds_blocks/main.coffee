class @main
  Dom : =>
    @container = @found.container

    @element = @tree.element.class
    @elements = []
    @push @element
  show : =>
    @on 'remove', (elem) => @elements.splice @getIndex(elem), 1

    @tree.add_button.class.on 'submit', @onAdd
    $('html').on 'click', => e.onRestore() for e in @elements

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

  push : (element) =>
#    element.setObserver @
    element.on 'event', (message) => @emit message, element
    element.flag = false
    @elements.push element

  onAdd : =>
    elem = @element.$clone()
    @push elem
    @add(elem, true).slideDown 400

  add : (element, is_open = false) =>
    element.reset()
    if is_open then element.showForm() else element.hideForm()
    block = $('<div class="block" style="display: none">').append element.dom
    @container.append block
    return block

  eachElem : (func) => func.call(e, i) for e, i in @elements


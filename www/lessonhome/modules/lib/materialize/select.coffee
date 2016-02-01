class _material_select extends EE
  LI = 'li:not(.optgroup)'
  constructor : (jQelem) ->
    @_sort = {}
    @elem = jQelem
    @is_multi = @elem[0].multiple
    @value = null
    @_default = "ds"
    @elem.find('option').each (i, e) =>
      o = $(e)
      v = o.attr('value')
      if v.length
        o.text(o.text() + "\#\{#{v}\}")
      else
        @_default = o.text()

    @elem.material_select()
    @ul = @elem.siblings('ul').on('mouseup touchend', LI, @_change)
    regexp = /^(.+)#{(.+)}$/
    @lis = @ul.find(LI)
    .each (i, li) =>
      li = $(li)
      textNode = @_getTextNode(li)
      text = textNode.text()
      text = text.match regexp

      if text?[1]? and text[2]?

        textNode[0].data = text[1]

        li.attr('data-value', text[2])
        @_sort[text[2]]?= {n:text[1], el:[]}
        @_sort[text[2]].el.push li

    @input = @elem.siblings('input')

    if @is_multi then @_preload()

    regexp = /#{.+}$/

    setTimeout =>
      @elem.find('option').each ->
        o = $(this)
        o.text(o.text().replace(regexp, ''))
    ,200

  _preload : =>
    exist = {}
    result = []
    vv = @elem.val()
    return [] unless vv
    for v in vv when not exist[v]
      exist[v] = true
      result.push v
    @val result

  _change : (e) =>
    li = $(e.currentTarget)
    name = li.attr('data-value')

    setTimeout =>
      if @_sort[name]?.el?.length > 1
        @_setCheckedLi(l, li.is '.active') for l in @_sort[name].el

      @value = @_getSelectedValues()
      @elem.val(@value)
      @_updateInput()
      @emit 'change', @
    ,0

    return true

  _getTextNode : (li) ->
    return li.find('span').contents().filter(-> return this.nodeType == 3)

  _setCheckedLi : (li, check = true) ->
    return if check == li.is '.active'
    if check then li.addClass('active') else li.removeClass('active')
    li.find('input[type="checkbox"]:first').prop('checked', check)

  _getSelectedValues : ->
    exist = {}
    $.map @lis, (li) =>
      li = $(li)
      val = li.attr('data-value')
      return if exist[val] or not li.is('.active')
      exist[val] = true
      return val

  _updateInput : ->
    value = @value.map (e) => @_sort[e].n
    @input[0].value = value.join(', ') || @_default

  _resetAllSelected : -> @lis.each (i, e) => @_setCheckedLi $(e), false

  val : (value) ->
    return @value unless value?
    @_resetAllSelected()
    @elem.val value
    @value = if value instanceof Array then value else [value]
    @_chekByArrValues(@value)
    @elem.trigger 'change'
    @_updateInput()
    return @elem

  _chekByArrValues : (values) -> @checkByValue(v) for v in values
  checkByValue : (name, check = true) ->
    if @_sort[name]?.el?
      @_setCheckedLi(li, check) for li in @_sort[name].el


$._material_select = _material_select
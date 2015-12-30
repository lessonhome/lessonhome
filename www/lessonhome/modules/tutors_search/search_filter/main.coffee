
class _material_select extends EE
  LI = 'li:not(.optgroup)'
  constructor : (jQelem) ->
    @_sort = {}
    @elem = jQelem
    @value = null

    @elem.find('option').each ->
      o = $(this)
      v = o.attr('value')
      o.text(o.text() + "\#\{#{v}\}") if v

    @elem.material_select()

    regexp = /^(.+)#{(.+)}$/

    @lis = @elem.siblings('ul')
    .on('mouseup touchend', LI, @_change)
    .find(LI)
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
    @_default = @input.val()
    @is_multi = @elem.multiple

  if @is_multi then @_preload()

  _preload : =>
    exist = {}
    result = []
    for v in @elem.val() when not exist[v]
      exist[v] = true
      result.push v
    @val result

  _change : (e) =>
    li = $(e.currentTarget)
    name = li.attr('data-value')
    setTimeout =>
      if @_sort[name]?.el?.length > 1
        @_setCheckedLi(l, li.is '.active') for l in @_sort[name].el
      @value = @_getSelectedNames()
      @_updateInput()
      @emit 'change'
    ,0

  _getTextNode : (li) ->
    return li.find('span').contents().filter(-> return this.nodeType == 3)

  _setCheckedLi : (li, check = true) ->
    return if check == li.is '.active'
    if check then li.addClass('active') else li.removeClass('active')
    li.find('input[type="checkbox"]:first').prop('checked', check)

  _getSelectedNames : ->
    exist = {}
    $.map @lis, (li) =>
      li = $(li)
      name = li.attr('data-value')
      return if exist[name] or not li.is('.active')
      exist[name] = true
      return name

  _updateInput : ->
    value = @value.map (e) => @_sort[e].n
    @input.val(value.join(', ') || @_default)

  _resetAllSelected : -> @lis.each (i, e) => @_setCheckedLi $(e), false

  val : (value) ->
    return @value unless value?
    @_resetAllSelected()
    @elem.val value
    @value = if value instanceof Array then value else [value]
    @_chekByArrNames(@value)
    @elem.trigger 'change'
    @_updateInput()
    return @elem

  _chekByArrNames : (value) -> @checkByName(v) for v in value
  checkByName : (name, check = true) ->
    if @_sort[name]?.el?
      @_setCheckedLi(li, check) for li in @_sort[name].el

class slideBlock extends EE
  constructor : (parent, inputs = null) ->
    @inputs = inputs || parent.find '[data-v]'
    @parent = parent
    .on('click', 'input[type=radio][data-v], input[type=checkbox][data-v]', @_change)
    .on('blur', 'input[type=text][data-v]', @_change)
    .on('change', 'select[data-v]', @_change)
    @indicator = parent.find('.i-header')
    @_change()

  _change : =>
    @_updateIndicator()
    @emit 'change'

  _updateIndicator : =>
    @inputs.each (index, input) =>
      exist = null

      switch input.type
        when 'checkbox', 'radio'
          exist = input.checked
        else
          exist = input.value

      if exist and not $(input).is '.i-no'
        @_setIndicator true
        return false
      @_setIndicator false
      return true

  _setIndicator : (val = true) ->
    if val
      @indicator.addClass 'selected'
    else
      @indicator.removeClass 'selected'

  _getValue : ->
    result = {}
    @inputs.each (i) ->
      el = $(this)
      name = el.data('v')
      type = this.type

      result[name]?={}

      switch type
        when 'checkbox'
          result[name][el.val()] = true if el.is ':checked'
        when 'radio'
          result[name] = el.val() if el.is ':checked'
        else
          result[name] = el.val()

    return result

  _resetAll : ->
    @inputs.each ->
      switch this.type
        when 'radio', 'checkbox'
          $(this).prop('checked', false)
        else
          $(this).val('')

  _setValue : (data) ->
    @_resetAll()
    for key, values of data
      if typeof(values) == 'object'
        @inputs.filter("[data-v=\"#{key}\"]")
        .each (i, input) ->
          $(input).prop('checked', true) if values[input.value]

      else if typeof(values) == 'string'
        input = @inputs.filter("[data-v=\"#{key}\"]")
        if input[0].type == 'radio'
          input.filter("[value=\"#{values}\"]").prop "checked", true
        else
          input.val values
#          console.log input.prop('tagName')
          input.trigger('change') if input.prop('tagName') == 'SELECT'

  val : (data) ->
    return @_getValue() unless data
    @_setValue(data)
    @_updateIndicator()

class @main
  constructor : ->
    $W @
  Dom : =>
    @subjects = new _material_select @found.subjects
    @course = new _material_select @found.course
    @price = new slideBlock @found.price_block
    @status = new slideBlock @found.status_block
    @sex = new slideBlock @found.sex_block
    @metro = new slideBlock @found.metro_location

    @branch = new _material_select @found.branch


    @dom.find('.optgroup').on 'click', (e)=>
      thisGroup = e.currentTarget
      thisGroupNumber = $(thisGroup).attr('data-group')
      thisOpen = $(thisGroup).attr('data-open')
      if thisOpen == '0'
        $('li[class*="subgroup"]').slideUp(400)
        $('.optgroup').attr('data-open', 0)
        $('.subgroup_' + thisGroupNumber).slideDown(400)
        $(thisGroup).attr('data-open', 1)
      else
        $('.subgroup_' + thisGroupNumber).slideUp(400)
        $(thisGroup).attr('data-open', 0)



  show: =>
#    Feel.urlData.on 'change',=> do Q.async =>
#      hash = yield Feel.urlData.filterHash 'tutorsFilter'
#      console.log hash,@hash==hash
#      @hash = hash

    @subjects.on 'change', => Feel.urlData.set 'tutorsFilter', {subjects: @subjects.val()}
    @course.on 'change', => Feel.urlData.set 'tutorsFilter', {course: @course.val()}
    @price.on 'change', => Feel.urlData.set 'tutorsFilter', @price.val()
    @status.on 'change', => Feel.urlData.set 'tutorsFilter', @status.val()
    @sex.on 'change', => Feel.urlData.set 'tutorsFilter', @sex.val()
    @branch.on 'change', => Feel.urlData.set 'tutorsFilter', {branch: @branch.val()}


    @found.use_settings.on 'click', =>
      top = @dom.offset?()?.top
      $(window).scrollTop top-10 if top >= 0
      @emit 'reshow'
#      Q.spawn => yield Feel.urlData.set 'tutorsFilter', @getValue()

  getValue : =>
    metro = @metro.val()
    return {
      subjects: @subjects.val()
      course: @course.val()
      price: @price.val().price
      status: @status.val().status
      sex: @sex.val()?.sex
      branch: metro.branch
    }

  setValue : (value) =>
    value = value.filter
    @subjects.val value.subjects
    @course.val value.course
    @price.val {price: value.price}
    @status.val {status: value.status}
    @sex.val {sex: value.sex}
    @branch.val value.branch


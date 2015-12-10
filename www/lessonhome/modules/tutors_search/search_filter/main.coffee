
class _material_select extends EE
  LI = 'li:not(.optgroup)'
  constructor : (jQelem) ->
    this._sort = {}
    this.elem = jQelem
    this.value = null
    this.elem.material_select()
    this.input = @elem.siblings('input')
    this._default = this.input.val()

    this.lis = @elem.siblings('ul')
    .on('mouseup touchend', LI, this._change)
    .find(LI).each (i, li) =>
      li = $(li)
      name = this._ejectLiName(li)
      this._sort[name]?= []
      this._sort[name].push li

    this._preload()

  _preload : =>
    exist = {}
    result = []
    for v in this.elem.val() when not exist[v]
      exist[v] = true
      result.push v
    this._setSelVal result

  _change : (e) =>
    li = $(e.currentTarget)
    name = this._ejectLiName(li)
    setTimeout =>
      if this._sort[name]?.length > 1
        this._setLi(l, li.is '.active') for l in this._sort[name]
      this.value = this._getSelVal()
      this._updateInput()
      @emit 'change'
    ,0

  _ejectLiName : (li) -> li.find('span').text().trim()

  _setLi : (li, check = true) ->
    return if check == li.is '.active'
    if check then li.addClass('active') else li.removeClass('active')
    li.find('input[type="checkbox"]:first').prop('checked', check)

  _getSelVal : ->
    exist = {}
    $.map this.lis, (li) =>
      li = $(li)
      name = this._ejectLiName li
      return if exist[name] or not li.is('.active')
      exist[name] = true
      return name

  _updateInput : -> this.input.val(this.value.join(', ') || this._default)

  _resetSelVal : -> this.lis.each (i, e) => this._setLi $(e), false

  val : (value) ->
    return this.value unless value?
    this._setSelVal(value)
    return this.elem

  _setSelVal : (value) ->
    this._resetSelVal()
    this.setActive(v) for v in value
    this.elem.val value
    this.value = value
    this._updateInput()

  setActive : (name, check = true) ->
    if this._sort[name]?
      this._setLi(li, check) for li in this._sort[name]

class slideBlock extends EE
  constructor : (parent, inputs = null) ->
    this.inputs = inputs || parent.find 'input'
    this.parent = parent
    .on('click', 'input[type=radio], input[type=checkbox]', this._change)
    .on('blur', 'input[type=text]', this._change)
    this.indicator = parent.find('.i-header')
    this._change()

  _change : =>
    @_updInd()
    @emit 'change'

  _updInd : =>
    this.inputs.each (index, input) =>
      type = input.type || 'text'
      exist = (type!='text' and input.checked) or (type=='text' and input.value)

      if exist and not $(input).is '.i-no'
        @_setInd true
        return false
      @_setInd false
      return true

  _setInd : (val = true) ->
    if val
      this.indicator.addClass 'selected'
    else
      this.indicator.removeClass 'selected'

  _getVal : ->
    result = {}
    this.inputs.each (i) ->
      el = $(this)
      name = el.data('v')
      type = el.attr('type') || 'text'

      if (type == 'text' and el.val()) or (type == 'radio' and el.is ':checked')
        result[name] = el.val()
        return true

      result[name]?={}
      result[name][el.val()] = true if el.is ':checked'

    return result

  _setVal : (data) ->
    for key, values of data
      if typeof(values) == 'object'
        this.inputs.filter("[data-v=\"#{key}\"]")
        .each (i, input) ->
          $(input).prop('checked', true) if values[input.value]

      else if typeof(values) == 'string'
        input = this.inputs.filter("input[data-v=\"#{key}\"]")
        type = input.attr('type') || 'text'
        if type == 'text'
          input.val values
        else if type == 'radio'
          input.filter("[value=\"#{values}\"]").prop "checked", true

  val : (data) ->
    return @_getVal() unless data
    @_setVal(data)
    this._updInd()

class @main
  constructor : ->
    $W @
  Dom : =>
    @subjects = new _material_select @found.subjects
    @course = new _material_select @found.course
    @price = new slideBlock @found.price_block
    @status = new slideBlock @found.status_block
    @sex = new slideBlock @found.sex_block

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
    @subjects.on 'change', => Feel.urlData.set 'tutorsFilter', {subjects: @subjects.val()}
    @course.on 'change', => Feel.urlData.set 'tutorsFilter', {course: @course.val()}
    @price.on 'change', => Feel.urlData.set 'tutorsFilter', @price.val()
    @status.on 'change', => Feel.urlData.set 'tutorsFilter', @status.val()
    @sex.on 'change', => Feel.urlData.set 'tutorsFilter', @sex.val()
    @found.use_settings.on 'click', => Q.spawn => yield Feel.urlData.set 'tutorsFilter', @getValue()

  getValue : =>
    subjects : @subjects.val()
    course : @course.val()
    price : @price.val().price
    status : @status.val().status
    sex : @sex.val()?.sex

  setValue : (value) =>
    value = value.filter
    @subjects.val value.subjects
    @course.val value.course
    @price.val {price: value.price}
    @status.val {status: value.status}
    @sex.val {sex: value.sex}


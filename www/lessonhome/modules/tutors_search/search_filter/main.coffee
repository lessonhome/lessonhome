
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
    .find(LI)
    .each (i, li) =>
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
    this._chekByArrNames result

  _change : (e) =>
    li = $(e.currentTarget)
    name = this._ejectLiName(li)
    setTimeout =>
      if this._sort[name]?.length > 1
        this._setCheckedLi(l, li.is '.active') for l in this._sort[name]
      this.value = this._getSelectedNames()
      this._updateInput()
      @emit 'change'
    ,0

  _ejectLiName : (li) -> li.find('span').text().trim()

  _setCheckedLi : (li, check = true) ->
    return if check == li.is '.active'
    if check then li.addClass('active') else li.removeClass('active')
    li.find('input[type="checkbox"]:first').prop('checked', check)

  _getSelectedNames : ->
    exist = {}
    $.map this.lis, (li) =>
      li = $(li)
      name = this._ejectLiName li
      return if exist[name] or not li.is('.active')
      exist[name] = true
      return name

  _updateInput : -> this.input.val(this.value.join(', ') || this._default)

  _resetAllSelected : -> this.lis.each (i, e) => this._setCheckedLi $(e), false

  val : (value) ->
    return this.value unless value?
    this._chekByArrNames(value)
    return this.elem

  _chekByArrNames : (value) ->
    this._resetAllSelected()
    this.checkByName(v) for v in value
    this.elem.val value
    this.value = value
    this._updateInput()

  checkByName : (name, check = true) ->
    if this._sort[name]?
      this._setCheckedLi(li, check) for li in this._sort[name]

class slideBlock extends EE
  constructor : (parent, inputs = null) ->
    console.log 'parent', parent
    this.inputs = inputs || parent.find 'input[data-v]'
    this.parent = parent
    .on('click', 'input[type=radio][data-v], input[type=checkbox][data-v]', this._change)
    .on('blur', 'input[type=text][data-v]', this._change)
    this.indicator = parent.find('.i-header')
    this._change()

  _change : =>
    @_updateIndicator()
    @emit 'change'

  _updateIndicator : =>
    this.inputs.each (index, input) =>
      type = input.type || 'text'
      exist = (type!='text' and input.checked) or (type=='text' and input.value)

      if exist and not $(input).is '.i-no'
        @_setIndicator true
        return false
      @_setIndicator false
      return true

  _setIndicator : (val = true) ->
    if val
      this.indicator.addClass 'selected'
    else
      this.indicator.removeClass 'selected'

  _getValue : ->
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

  _setValue : (data) ->
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
    return @_getValue() unless data
    @_setValue(data)
    this._updateIndicator()

class @main
  constructor : ->
    $W @
  Dom : =>
    console.log @found
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
    Feel.urlData.on 'change',=> do Q.async =>
      hash = yield Feel.urlData.filterHash 'tutorsFilter'
      console.log hash,@hash==hash
      @hash = hash
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
#    value = value.filter
#    @subjects.val value.subjects
#    @course.val value.course
#    @price.val {price: value.price}
#    @status.val {status: value.status}
#    @sex.val {sex: value.sex}


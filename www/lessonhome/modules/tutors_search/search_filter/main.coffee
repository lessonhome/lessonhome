
class _material_select extends EE
  LI = 'li:not(.optgroup)'
  constructor : (jQelem) ->
    this._sort = {}
    this.value = null
    this.elem = jQelem
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
  _change : (e) =>
    li = $(e.currentTarget)
    name = this._ejectLiName(li)
    setTimeout =>
      if this._sort[name]?.length > 1
        this._setLi(l, li.is '.active') for l in this._sort[name]
      this.value = this._getSelVal()
      this._updateInput()
      this.emit 'change'
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

class @main
  constructor : ->
    $W @
  Dom : =>
    @elems = @dom.find "[name='subject'],[name='course'],[name='price'],[name='status'],[name='sex']"

    @subjects = @elems.filter "[name='subject']"
    @course = @elems.filter "[name='course']"
    @prices = @elems.filter "[name='price']"
    @status = @elems.filter "[name='status']"
    @sex = @elems.filter "[name='sex']"

    @indicate = @found.indicate

    @subjects = new _material_select @subjects
    @course = new _material_select @course

    @subjects.on 'change', => console.log 'subj'
    @course.on 'change', => console.log 'cour'

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

    @found.use_settings.on 'click', =>
      Feel.urlData.set('tutorsFilter', @getValue())

    @indicate.on 'click', 'input', (e) =>
      inp = $(e.currentTarget)
      indicate = inp.closest('.i-block').find('.i-header')

      switch indicate.data('type')
        when 'sex'
          if inp.val().toLowerCase() is 'не важно'
            indicate.removeClass('selected')
          else
            indicate.addClass('selected')
        else
          count = indicate.data 'check'
          if inp.is(':checked') then count += 1 else count -= 1
          indicate.data('check', count)

          if count
            indicate.addClass('selected')
          else
            indicate.removeClass('selected')

      @emit 'change'

  getValue : =>
    subjects : @subjects.val()
    course : @course.val()
    price : @getCheck @prices
    status : @getCheck @status
    sex : @getCheck(@sex)[0] || ''

  setValue : (value) =>
    @subjects.val(value.subjects || [])


  getCheck : (sel) =>
    $.map sel, (el) ->
      return unless $(el).is(':checked')
      return el.value

  setChek : (sel, val) =>
    sel.filter(("[value=\"#{s}\"]" for s in val).join(',')).prop('checked', true)

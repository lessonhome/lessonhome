
class _material_select extends EE
  constructor : (jQelem) ->
    this._values = {}
    this.elem = jQelem
    this.elem.material_select()
    this.input = @elem.siblings('input')
    this._default = this.input.val()
    this.li = @elem.siblings('ul')
    .on('mouseup touchend', 'li', this._change)
    .find('li').each (i, e) =>
      return if $(e).is('.optgroup')
      val = $(e).find('span').text().trim()
      this._values[val]?= $()
      this._values[val].add e
  _change : =>
    setTimeout =>
      value = this._getSelVal()
      this.elem.val value
      this.input.val(value.join(', ') || this._default)
      this.emit 'change'
    ,0

  _getSelVal : ->
    exist = {}
    $.map this.li, (el) ->
      value = $(el).find('span').text().trim()
      return if exist[l = value.toLowerCase()] or not $(el).is('.active')
      exist[l] = true
      return value

  _setSelVal : (value) ->
    this.elem.val value
    this.input.val(value.join(', ') || this._default)

    for v in value
      this._values[v]?.addClass 'active'
      .find('input[type="checkbox"]').prop('checked', true)

  val : (value) ->
    if value?.length
      this._setSelVal(value)
      return this.elem
    else
      return this.elem.val()


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
      console.log @getValue()

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

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
    setTimeout =>
      @_updateIndicator()
      @emit 'change'
    ,0

  _updateIndicator : =>
    @inputs.each (index, input) =>
      exist = null

      switch input.type
        when 'checkbox', 'radio'
          exist = input.checked
        else
          v = $(input).val()
          exist = v && v.length

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
    @inputs.each ->
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
          input.trigger('change') if input.prop('tagName') == 'SELECT'

  val : (data) ->
    return @_getValue() unless data
    @_setValue(data)
    @_updateIndicator()

class @main
  constructor : ->
    $W @
  Dom : =>
    @subjects = @found.subjects
    @course = @found.course

    @subjects.material_select()
    @course.material_select()

    @price = new slideBlock @found.price_block
    @status = new slideBlock @found.status_block
    @sex = new slideBlock @found.sex_block
    @metro = new slideBlock @found.metro_location
    @branch = @found.branch
    @branch.material_select()
    setTimeout @metroColor, 100

  metroColor : =>
    @branch.siblings('ul').find('li.optgroup').each (i, e) =>
      li = $(e)
      name = li.next().attr('data-value')
      return true unless name
      name = name.split(':')
      return true if name.length < 2
      return true unless @tree.metro_lines[name[0]]?
      elem = $('<i class="material-icons middle-icon">fiber_manual_record</i>')
      elem.css {color: @tree.metro_lines[name[0]].color}
      li.find('span').prepend(elem)
  show: =>
#    Feel.urlData.on 'change',=> do Q.async =>
#      hash = yield Feel.urlData.filterHash 'tutorsFilter'
#      console.log hash,@hash==hash
#      @hash = hash
    ejectUnique = (arr = []) =>
      result = []
      exist = {}
      (result.push(a); exist[a] = true) for a in arr when !exist[a]?
      return result

    @subjects.on 'change', =>
      subjects = ejectUnique @subjects.val()
      Q.spawn => Feel.urlData.set 'tutorsFilter', {subjects}
      for s in subjects


    @course.on 'change', => Q.spawn => Feel.urlData.set 'tutorsFilter', {course: @course.val()}
    @price.on 'change', => Q.spawn => Feel.urlData.set 'tutorsFilter', @price.val()
    @status.on 'change', => Q.spawn => Feel.urlData.set 'tutorsFilter', @status.val()
    @sex.on 'change', => Q.spawn => Feel.urlData.set 'tutorsFilter', @sex.val()
    @branch.on 'change', => Q.spawn => Feel.urlData.set 'tutorsFilter', {metro: ejectUnique @branch.val()}


    @found.use_settings.on 'click', =>

      $("body, html").animate {
          "scrollTop":0
        }, 200

      Feel.urlData.emit 'change', true
#      top = @dom.offset?()?.top
#      $(window).scrollTop top-70 if top >= 0
      return false

#      Q.spawn => yield Feel.urlData.set 'tutorsFilter', @getValue()

  sinchCourse : (subject) =>
    @tree.

  getValue : =>
    return {
      subjects: @subjects.val()
      course: @course.val()
      price: @price.val().price
      status: @status.val().status
      sex: @sex.val().sex
    }

  setValue : (value) =>
    value = value.filter
    @subjects.val value.subjects
    @course.val value.course
    @price.val {price: value.price}
    @status.val {status: value.status}
    @sex.val {sex: value.sex}
    @branch.val value.metro
    @subjects.trigger('update')
    @course.trigger('update')
    @branch.trigger('update')


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
    @subjects = @tree.subject_select.class
    @course = @found.course
    @branch = @tree.metro_select.class

    @course.material_select()

    @price = new slideBlock @found.price_block
    @status = new slideBlock @found.status_block
    @sex = new slideBlock @found.sex_block

    setTimeout @metroColor, 100


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

    @subjects.select.on 'change', =>
      subjects = ejectUnique @subjects.val()
      Q.spawn => Feel.urlData.set 'tutorsFilter', {subjects}
#      @_syncCourse subjects

    @course.on 'change', => Q.spawn => Feel.urlData.set 'tutorsFilter', {course: @course.val() ? []}
    @price.on 'change', => Q.spawn => Feel.urlData.set 'tutorsFilter', @price.val()
    @status.on 'change', => Q.spawn => Feel.urlData.set 'tutorsFilter', @status.val()
    @sex.on 'change', => Q.spawn => Feel.urlData.set 'tutorsFilter', @sex.val()
    @branch.select.on 'change', => Q.spawn => Feel.urlData.set 'tutorsFilter', {metro: ejectUnique @branch.val()}


    @found.use_settings.on 'click', =>

      $("body, html").animate {
          "scrollTop":0
        }, 200

      Feel.urlData.emit 'change', true
#      top = @dom.offset?()?.top
#      $(window).scrollTop top-70 if top >= 0
      return false

#      Q.spawn => yield Feel.urlData.set 'tutorsFilter', @getValue()

  _getSections : (subjects) =>
    sections = []
    len = subjects.length

    if len
      obj_sub = {}
      obj_sub[s] = true for s in subjects
      for own section, subjects of @tree.subject_list
        i = 0
        while len and (subject = subjects[i++])?

          if obj_sub[subject]
            sections.push section
            len--

        break unless len

    return sections


  _syncCourse : (subjects) =>
    subjects = [undefined] unless subjects and subjects.length
    exist = {}
    numbers = {}
    reg = /\s*\-\s*/
    def = [1,2,3,4,5,6,7]
    for subject in subjects

      if subject
        rules = @tree.rules_sync[subject]

        unless rules
          sections = @_getSections([subject])
          (rules = @tree.rules_sync[sections]; break) for s in sections when @tree.rules_sync[sections]?

      rules ?= def

      for own key, g of rules when !exist[g]?
        exist[g] = true
        curr_group = @tree.group[g].split(reg)

        if curr_group.length == 1
          numbers[ curr_group[0] ] = true
        else if curr_group.length == 2
          i = +curr_group[0]
          last_num = +curr_group[1]
          while i <= last_num then numbers[i++] = true

    len = @course.siblings('ul.select-dropdown')
    .find('li:not(.disabled)')
    .each (i) -> $(this).toggleClass('hidden_label', !numbers[i])
    .filter(':not(.hidden_label), .active').length

    @course.trigger('close') if !len
    @course.siblings('input.select-dropdown').prop('disabled', !len)


#          @course.append("<option value='#{course}'>#{course}</option>")

#    (@course.prop('disabled', false); break) for own e of exist

#    @course.prepend("<option value='' disabled='disabled' selected='selected'>Направление подготовки</option>").material_select()
#    @course.trigger('change')


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
    @_syncCourse value.subjects
    @course.val value.course
    @price.val {price: value.price}
    @status.val {status: value.status}
    @sex.val {sex: value.sex}
    @branch.val value.metro
    @subjects.trigger('update')
    @course.trigger('update')
#    @branch.trigger('update')


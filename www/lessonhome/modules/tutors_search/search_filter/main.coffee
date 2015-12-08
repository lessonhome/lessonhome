

class @main
  constructor : ->
    $W @
  Dom : =>
    elems = @dom.find "[name='subject'],[name='course'],[name='price'],[name='status'],[name='sex']"

    @subjects = elems.filter "[name='subject']"
    @course = elems.filter "[name='course']"
    @prices = elems.filter "[name='price']"
    @status = elems.filter "[name='status']"
    @sex = elems.filter "[name='sex']"

    @indicate = @found.indicate

    @subjects.material_select()
    @course.material_select()

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
    ############
    @_sub = null
    @_input_sub = @subjects.siblings('input')
    @_li_sub = @subjects.siblings('ul').on('mouseup touchend', 'li', @changeSub).find('li')
  #######################
    @_course = null
    @_li_course = @course.siblings('ul').on('mouseup touchend', 'li', @changeCourse).find('li')
  ########################

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



  changeSub : =>
    setTimeout =>
      @_sub = @_getSel @_li_sub
      @_input_sub.val(if @_sub?.length then @_sub.join(', ') else 'Предмет')
      @emit 'change'
    ,0
  changeCourse : =>
    setTimeout =>
      @_course = @_getSel @_li_course
      @emit 'change'
    ,0
  #######################
  _getSel : (li) =>
    $.map li, (el) ->
      return unless $(el).is('.active')
      return $(el).find('span').text().trim()
  #######################
  getCheck : (sel) =>
    $.map sel, (el) ->
      return unless $(el).is(':checked')
      return el.value

  getValue : =>
    subjects : @getSub()
    course : @getCourse()
    price : @getPrice()
    status : @getStatus()
    sex : @getSex()

  getSub : => @_sub || []
  getCourse : => @_course || []
  getPrice : => @getCheck @prices
  getStatus : => @getCheck @status
  getSex : => @getCheck(@sex)[0] || ''


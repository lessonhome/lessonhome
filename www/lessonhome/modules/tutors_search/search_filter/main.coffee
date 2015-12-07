

class @main
  constructor : ->
    $W @
  Dom : =>
    elems = @dom.find("[name='subject'],[name='course'],[name='price'],[name='status'],[name='sex']")

    @subjects = elems.filter("[name='subject']")
    @course = elems.filter("[name='course']")
    @price = elems.filter("[name='price']")
    @status = elems.filter("[name='status']")
    @sex = elems.filter("[name='sex']")

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


    @_sub = null
    @_input_sub = @subjects.siblings('input')
    @_li_sub = @subjects.siblings('ul').on('mouseup touchend', 'li', =>
      setTimeout(
        (=>
          @_sub = @_getSel @_li_sub
          @_input_sub.val if @_sub?.length then @_sub.join(', ') else 'Предмет'
        )
        ,0
      )
    ).find('li')

    @_course = null
    @_li_course = @course.siblings('ul').on('mouseup touchend', 'li', =>
      setTimeout(
        (=>
          @_course = @_getSel @_li_course
        )
      )
    ).find('li')

  _getSel : (li) =>
    r = []
    li.filter('.active').each -> r.push $(this).find('span').text().trim()
    return r




  getSub : => @_sub

  getCourse : => @_course

  getValue : =>
    subjects : @getSub()
    course : @getCourse()
    price : @getPrice()
    status : @getStatus()
    sex : @getSex()

  @getPrice : =>

  getStatus : =>

  getSex : =>

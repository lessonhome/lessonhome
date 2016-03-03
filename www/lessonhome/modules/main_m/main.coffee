

class @main
  constructor: ->
    $W @
  Dom : =>
    @found.fast_sub.material_select()
    @found.fast_branch.material_select()

    @fast_form =
      subjects: @found.fast_sub
      metro: @found.fast_branch

    setTimeout @metroColor, 100

  _ejectUnique : (arr = []) =>
    result = []
    exist = {}
    (result.push(a); exist[a] = true) for a in arr when !exist[a]?
    return result

  _getListener : (name, element) -> =>
    Q.spawn =>
      value = element.val()

      switch name
        when 'subjects'
          value = @_ejectUnique value

      yield Feel.sendActionOnce('interacting_with_form', 1000*60*10)
      yield Feel.urlData.set 'tutorsFilter', name, value

  show: =>
    @fast_form.subjects.on 'change', @_getListener('subjects', @fast_form.subjects)
    @fast_form.metro.on 'change', @_getListener('metro', @fast_form.metro)

    @found.attach.on    'click', => Q.spawn => Feel.jobs.solve 'openBidPopup', null, 'motivation'
    @found.send_form.on 'click', => Q.spawn => @sendFastForm()

    Q.spawn =>
      indexes = []
      for own key, t of @tree.main_rep then indexes.push t.index
      yield Feel.dataM.getTutor indexes

  sendFastForm: =>
    subjects = @_ejectUnique @fast_form.subjects.val()
    metro = @fast_form.metro.val()
    @found.fast_filter.attr('action', "/search?#{ yield Feel.udata.d2u 'tutorsFilter', {subjects, metro}}")
    @found.fast_filter.submit()

  metroColor :  =>
    @found.fast_branch.siblings('ul').find('li.optgroup').each (i, e) =>
      li = $(e)
      name = li.next().attr('data-value')
      return true unless name
      name = name.split(':')
      return true if name.length < 2
      return true unless @tree.metro_lines[name[0]]?
      elem = $('<i class="m_icon icon_fiber_manual_record middle-icon"></i>')
      elem.css {color: @tree.metro_lines[name[0]].color}
      li.find('span').prepend(elem)

  getValue:  =>

  setValue : (data) ->
    console.log data
    @fast_form.subjects.val(data.subjects).trigger('update')
    @fast_form.metro.val(data.metro).trigger('update')

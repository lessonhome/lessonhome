

class @main
  constructor: ->
    $W @
  Dom : =>
    @subjects = @tree.select_sub.class
    @metro = @tree.select_metr.class

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
    @subjects.select.on 'change', @_getListener('subjects', @subjects)
    @metro.select.on 'change', @_getListener('metro', @metro)

    @found.attach.on    'click', => Q.spawn => Feel.jobs.solve 'openBidPopup', null, 'motivation'
    @found.send_form.on 'click', => Q.spawn => @sendFastForm()

    Q.spawn =>
      indexes = []
      for own key, t of @tree.main_rep then indexes.push t.index
      yield Feel.dataM.getTutor indexes

  sendFastForm: =>
    subjects = @_ejectUnique @subjects.val()
    metro = @metro.val()
    @found.fast_filter.attr('action', "/search?#{ yield Feel.udata.d2u 'tutorsFilter', {subjects, metro}}")
    @found.fast_filter.submit()

  setValue : (data) ->
    @subjects.val(data.subjects)
    @metro.val(data.metro)
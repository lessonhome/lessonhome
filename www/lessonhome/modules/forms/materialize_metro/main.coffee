class @main extends EE
  Dom: =>
    @select = @found.select
    @select.material_select()
    setTimeout @_metroColor, 100
  val : (value) => return if value? then @select.val(value) else @select.val()
  setValue : (value) => @val(value).trigger('update')
  getValue : => @val()
  _metroColor : =>
    @select.siblings('ul').find('li.optgroup').each (i, e) =>
      li = $(e)
      name = li.next().attr('data-value')
      return true unless name
      name = name.split(':')
      return true if name.length < 2
      return true unless @tree.metro_stations[name[0]]?
      elem = $('<i class="m_icon icon_fiber_manual_record middle-icon"></i>')
      elem.css {color: @tree.metro_stations[name[0]].color}
      li.find('span').prepend(elem)
class @main extends EE
  Dom: =>
    @select = @found.select
    @select.material_select()
    setTimeout @_metroColor, 100
  val : (value) => return if value? then @select.val(value) else @select.val()
  setValue : (value) => @val(value).trigger('update')
  getValue : => @val()
  _metroColor : =>
    group = @select.siblings('ul').find('li.optgroup')
    @select.find('optgroup').each (i, e) =>
      li = group.eq(i)
      name = $(e).data('value');
      return true unless @tree.metro_stations[name]?
      elem = $('<i class="m_icon icon_fiber_manual_record middle-icon"></i>')
      elem.css {color: @tree.metro_stations[name].color}
      li.find('span').prepend(elem)
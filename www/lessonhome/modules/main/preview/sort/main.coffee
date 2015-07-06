
class @main extends EE
  Dom : =>
    @items = ['price', 'experience', 'way_time'] # sort items
    @price      = @found.price
    @experience = @found.experience
    @way_time   = @found.way_time
    @show_list  = @found.show_list
    @show_grid  = @found.show_grid

  show : =>
    $(@price).on 'click', =>
      @changeDirection @price
      @setItemActive   @price
      @setItemInactive @experience
      @setItemInactive @way_time

    $(@experience).on 'click', =>
      @changeDirection @experience
      @setItemActive   @experience
      @setItemInactive @price
      @setItemInactive @way_time

    $(@way_time).on 'click', =>
      @changeDirection @way_time
      @setItemActive   @way_time
      @setItemInactive @price
      @setItemInactive @experience

    $(@show_list).on 'click', =>
      return if @show_list.hasClass 'active'
      @show_list.addClass 'active'
      @show_grid.removeClass 'active'

    $(@show_grid).on 'click', =>
      return if @show_grid.hasClass 'active'
      @show_grid.addClass 'active'
      @show_list.removeClass 'active'

  changeDirection : (div)=>
    if div.hasClass 'active'
      div.toggleClass 'up'
      @emit 'change'
      @emit 'end'
    return 0
  getValue : =>
    ret = []
    i = 0
    for section in @sections
      item = {}
      section = $ section
      item.title = @items[i++]
      if section.hasClass 'up'
        item.value = 'up'
      else
        item.value = 'down'
      ret.push item
    return ret


  setItemActive: (div)=>
    return if div.hasClass 'active'
    div.addClass 'active'
    return 0

  setItemInactive: (div)=>
    return if !div.hasClass 'active'
    div.removeClass 'active'
    return 0
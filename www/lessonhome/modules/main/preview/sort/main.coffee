
class @main extends EE
  Dom : =>
    @items = ['price', 'experience', 'rating'] # sort items
  show : =>
    $(window).on 'scroll', @scroll
    for item in @items
      do (item)=>
        @found[item].on 'click',=>
          unless @tree.value.sort == item
            @tree.value.sort = item
          else
            @tree.value.sort = '-'+item
          @setValue()
          @emit 'change'

    @found.show_list?.on 'click', =>
      @tree.value.show = 'list'
      @setValue()
      @emit 'change'

    @found.show_grid?.on 'click', =>
      @tree.value.show = 'grid'
      @setValue()
      @emit 'change'
    @setValue()
    @scroll()
  scroll : =>
    unless @fixed
      l = @dom.offset().top-$(window).scrollTop()
      return unless (l < 4)
      @dom.addClass 'fixed'
      @dot = @dom.offset().top
      unless @fixed?
        @wi = @dom.width()
        @he = @dom.height()
      @fixed = true
      @dom.css {
        position : 'fixed'
        height   : @he
        width    : @wi
        'z-index' : 1000
        top      : 4
      }
    else
      l = @dot-$(window).scrollTop()
      return if (l < 4)
      @dom.removeClass 'fixed'
      @fixed = false
      @dom.css {
        position : 'relative'
        top      : 0
      }

  getValue : => @tree.value
  setValue : (val=@tree.value)=>
    @tree.value.sort = val.sort if val.sort?
    @tree.value.show = val.show if val.show?
    item = @tree.value.sort.replace '-',''
    for it in @items
      @found[it].removeClass  'up'
      @found[it].removeClass  'active'
    @found[item].addClass 'active'
    unless @tree.value.sort == item
      @found[item].addClass 'up'
    if @tree.value.show == 'list'
      @found.show_list.addClass 'active'
      @found.show_grid.removeClass 'active'
    else
      @found.show_grid.addClass 'active'
      @found.show_list.removeClass 'active'


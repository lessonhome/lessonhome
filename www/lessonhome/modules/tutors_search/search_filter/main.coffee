class @main
  constructor : ->
    $W @
  Dom : =>
    @rangeEl  = @found.range_ui
    @filterSelectors = @found.megaselect
    slider    = document.getElementById('slider')
  show: =>
    $(@filterSelectors).material_select()

    $('.optgroup').on 'click', (e)=>
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

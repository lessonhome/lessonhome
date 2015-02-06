
Feel.LabelHoverControl = (dom, val)->

  labels = dom.find 'label'

  for label in labels
    label = $(label)
    console.log label
    label_val = label.find(val)

    do (label_val)=>
      label.on 'mouseover', => label_val.first().addClass 'hover'
      label.on 'mouseout',  => label_val.first().removeClass 'hover'

Feel.FirstBidBorderRadius = (dom)->
  basic_block = dom.find ".basic_block"
  first_bid = basic_block.first()
  first_bid.css("border-top-left-radius", "0" )
  first_bid.css("border-top-right-radius", "0")


Feel.HashScrollControl = (dom)->
  hash = location.hash.substring(1)
  scrolltop_links =  $('a[scrolltop]')
  blocks = $('div[scrolltop]')
  blocks_position_y = []
  blocks_scrolltop  = []

  i = 0
  for val in blocks
    blocks_position_y[i] =  $(val).offset().top
    blocks_scrolltop[i]  =  $(val).attr('scrolltop')
    i++

  i = 0
  if hash
    for val in blocks
      if blocks_scrolltop[i] == hash then $('body').scrollTop(blocks_position_y[i])
      i++

  for value in scrolltop_links
    value = $(value)
    scrolltop = value.attr('scrolltop')
    do(value, scrolltop)=>
      value.on 'click', =>
        result = value.attr("href").indexOf(location.pathname)
        if result < 0 then return true
        i = 0
        for val in blocks
          if blocks_scrolltop[i] == scrolltop then $('body').scrollTop(blocks_position_y[i])
          i++
        return true


  $(window).scroll( =>
    current_y = $('body').scrollTop()
    hash = location.hash.substring(1)
    i = 0
    limit = ( blocks_position_y.length - 1 )
    for val in blocks_position_y
      if i < limit
        if ( current_y >= blocks_position_y[i]  && current_y < blocks_position_y[i+1] )
          location.hash = blocks_scrolltop[i]
      else
        if  current_y >= blocks_position_y[i]
          location.hash = blocks_scrolltop[i]
      if current_y < blocks_position_y[0]
        location.hash = ""
        history.pushState('', document.title, window.location.pathname)
        $('body').scrollTop(current_y)
      i++
  )





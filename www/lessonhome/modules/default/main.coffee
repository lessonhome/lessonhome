
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
  if hash
    block_position_y = dom.find(".#{hash}").offset().top
    $("body").scrollTop(block_position_y)

  scrolltop_links =  $('a[scrolltop]')
  scrolltop_blocks = $('div[scrolltop]')
  blocks_position_y = []
  i = 0;
  for val in scrolltop_blocks
    blocks_position_y[i++] =  $(val).offset().top

  for value in scrolltop_links
    value = $(value)
    scrolltop = value.attr('scrolltop')
    do(value, scrolltop)=>
      value.on 'click', =>
        for val in scrolltop_blocks
          val = $(val)
          if val.attr('scrolltop') == scrolltop then $('body').scrollTop(val.offset().top)


  $(window).scroll( =>
    current_y = $('body').scrollTop()
    hash = location.hash.substring(1)
    own = false
    i = 0;
    for val in blocks_position_y
      if i < ( blocks_position_y.length - 1 )
        if ( current_y >= blocks_position_y[i]  && current_y < blocks_position_y[i+1] )
          location.hash = $(scrolltop_blocks[i]).attr("scrolltop")
      else
        if  current_y >= blocks_position_y[i]
          location.hash = $(scrolltop_blocks[i]).attr("scrolltop")
      if current_y < blocks_position_y[0]
        location.hash = ""
        history.pushState('', document.title, window.location.pathname)
        $('body').scrollTop(current_y)
      i++;
  )





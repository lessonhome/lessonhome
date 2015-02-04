
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
  blocks = $('[scrolltop]')
  if hash
    block_position_y = dom.find(".#{hash}").offset().top
    $("body").scrollTop(block_position_y)




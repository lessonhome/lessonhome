
Feel.LabelHoverControl = (dom, val)->

  labels = dom.find 'label'

  for label in labels
    label = $(label)
    label_val = label.find(val)

    do (label_val)=>
      label.on 'mouseover', => label_val.addClass 'hover'
      label.on 'mouseout',  => label_val.removeClass 'hover'


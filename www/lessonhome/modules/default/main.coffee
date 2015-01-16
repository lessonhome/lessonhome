
Feel.LabelHoverControl = (dom, val)->

  labels = dom.find 'label'

  for label in labels
    label = $(label)
    console.log label
    label_val = label.find(val)

    do (label_val)=>
      label.on 'mouseover', => label_val.first().addClass 'hover'
      label.on 'mouseout',  => label_val.first().removeClass 'hover'


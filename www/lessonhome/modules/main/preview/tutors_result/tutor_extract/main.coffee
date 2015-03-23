class @main extends EE
  show: =>
    @hideExtraText() # hide text that is larger than the maximum length and show full text by click
  hideExtraText: =>
    max_length = 147
    block = @found.tutor_text
    str   = @tree.tutor_text
    str_length = str.length
    if str_length > max_length
      visible_text = str.substring(0, max_length)
      block.html(visible_text)
      block.append('<div class="visible_text">...подробнее</div>')
      block.find(".visible_text").one 'click', => block.html(str)


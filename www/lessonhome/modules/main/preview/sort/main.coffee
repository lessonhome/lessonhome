
class @main extends EE
  Dom : =>
    @items = ['price', 'experience', 'way_time'] # sort items
    @sections = @found.section
  show : =>
    for section in @sections
      section = $ section
      do (section)=>
        section.on 'click', => @changeDirection section

  changeDirection : (section)=>
    section.toggleClass 'up'
    @emit 'change'
    @emit 'end'

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


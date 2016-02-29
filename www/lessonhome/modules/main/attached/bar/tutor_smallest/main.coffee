
class @main
  constructor : ->
    $W @
  show : =>
  setValue : (value={})=>
    @tree.value ?= {}
    @tree.value[key] = val for key,val of value
    link = '/tutor?'+(yield Feel.udata.d2u('tutorProfile',{index:@tree.value.index}))
    im = @tree.value.photos[@tree.value.photos.length-1]
    image = im.lurl
    n = @tree.value.name
    @found.avatar.attr 'src',image
    @found.avatar.attr 'alt',"#{n.last ? ''} #{n.first ? ''} #{n.middle ? ''}"
    @found.avatar.attr 'title',"#{n.last ? ''} #{n.first ? ''} #{n.middle ? ''}"

    #@dom.click => Feel.go(link)
    @found.photo_box.attr 'href',link
    index = @tree.value.index
    @dom.find('a').click (e)->
      return unless e.button == 0
      e.preventDefault()
      Feel.root.tree.class.showTutor index,$(this).attr('href')
      return false
#    h = im.lheight * 76/im.lwidth
#    return {h}

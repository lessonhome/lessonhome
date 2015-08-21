



class @main
  constructor : ->
    Wrap @
  show : =>
  setValue : (value={})=>
    @tree.value ?= {}
    @tree.value[key] = val for key,val of value
    link = '/tutor_profile?'+(yield Feel.udata.d2u('tutorProfile',{index:@tree.value.index}))
    im = @tree.value.photos[@tree.value.photos.length-1]
    image = im.lurl
    console.log link
    @found.img.attr 'src',image
    @dom.click => Feel.go(link)
    h = im.lheight * 76/im.lwidth
    return {h}

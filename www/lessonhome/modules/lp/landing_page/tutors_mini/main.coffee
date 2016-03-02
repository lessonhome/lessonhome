

class @main
  show : =>
  setValue : (value)=>
    a = @dom.find('a')
    a.attr 'href',value.link
    a.attr 'title',value.name
    @found.tm_name.text value.name
    @found.tm_photo_img.attr 'src',value.photos
    @found.tm_photo_img.attr 'alt',value.name
    @found.tm_price_middle.text value.left_price




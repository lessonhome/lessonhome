



class AddPhotos
  constructor : ->
    Wrap @
  Dom : =>
    @input = @found.input
    @photo = @found.photo
  show : =>
    @input.fileupload
      dataType : 'json'
      done : @done.out
      progressall : @progressall.out
  done : (e,data)=>
    @log e,data
    $.getJSON('/uploaded/image')
    .success (data)=>
      console.log data
      @setPhoto data.url,data.width,data.height
    .error (err)=>
      console.error err
    #d = yield Feel.json '/uploaded', data
    #@log d
    @resetInput()
  resetInput : =>
    @dom.find('input').remove()
    @found.wrap.append @input=$('<input accept="image/*" type="file" name="files[]" data-url="/upload/image" multiple="" class="input" />')
    @input.fileupload
      dataType : 'json'
      done : @done.out
      progressall : @progressall.out
  progressall : (e,data)=>
    @log e,data
  add : (e,data)=>
    @log e,data
    return true
  setPhoto : (url,w,h)=>
    a = h/w
    w = @dom.width()
    h = w*a
    dh = @dom.height()
    #if h > dh
    #  h = dh
    #  w = dh/a
    whide = @photo.find 'img'
    if whide.length == 0
      whide = @found.other
    img = $ "<img src='#{url}' width='100%' />"
    img.hide()
    img.css 'opacity',0
    img.appendTo @photo
    img.on 'load',=>
      console.log 'load'
      whide.animate({'opacity':0},500)
      setTimeout =>
        whide.remove()
        @photo.css {width : w,height:h}
        img.show()
        img.animate({opacity:1},500)
      ,500

@main = AddPhotos

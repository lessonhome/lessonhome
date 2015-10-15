



class AddPhotos
  constructor : ->
    $W @
  Dom : =>
    @front = @found.front
    @preloader = @found.preloader
    @input = @found.input
    @photo = @found.photo
    @photos = @found.photos
  show : =>
    once_click = true
    @input.blur -> once_click = true
    @input.click =>
      if once_click and !@input.is ':disabled'
        once_click = false
        return true
      return false
    @input.fileupload
      dataType : 'json'
      done : @done
      progressall : @progressall
      change : (e) =>
        @input = jQuery(e.target)
        @disable_loader()
    @found.remove_photo.click => Q.spawn => yield @remove_photo()
  remove_photo : =>
    return unless @found.photos.find('>.photo').length
    @disable_loader()
    yield @$send 'removeAva'
    $.getJSON('/uploaded/image')
    .success (data)=>
      @setPhoto data.url,data.width,data.height
    .error (err)=>
      console.error err
  done : (e,data)=>
    nowFile   = data?.files[data?.files?.length-1]
    lastFile  = data?.originalFiles?[data?.originalFiles?.length-1]
    return unless nowFile==lastFile
    @log e,data
    $.getJSON('/uploaded/image', {avatar: 'true'})
    .success (data)=>
      if data?.uploaded?
        photos = []
        for photo in data.uploaded
          unless photo.hash.match(/low|high/)
            photos.push photo
            Feel.sendActionOnce 'ava_upload'
            @setPhoto data.url,data.width,data.height
        @emit 'uploaded', photos.reverse()
    .error (err)=>
      console.error err
      @enable_loader()
  disable_loader : =>
    @input.prop "disabled", true
    @preloader.show()
    @front.hide()
  enable_loader : =>
    @preloader.hide()
    @front.show()
    @input.prop "disabled", false
  resetInput : =>
    @dom.find('input').remove()
    @found.input_wrap.append @input=$('<input accept="image/*" type="file" name="files[]" data-url="/upload/image" multiple="" class="input" />')
    @input.fileupload
      dataType : 'json'
      done : @done
      progressall : @progressall
      progress : @start
      start: @start
  start : (e,data)=>
    @input.css {
      opacity: 0.5
    }
  progressall : (e,data)=>
    #Feel.pbar.start()
    Feel.pbar.set data.loaded*0.5/data.total
    @log 'pall',e,data
  progressdone : (e,data)=>
    @log 'done',e,data
  add : (e,data)=>
    @log e,data
    return true
  setPhoto : (url,w,h)=>

    miniature = document.getElementById('m-mime-photo').firstElementChild

    max = 55
    mw = w
    mh = h
    if mw >= mh
      if mw>max
        a = max/mw
        mw *= a
        mh *=a

    else if mh > mw
      if h>max
        a=max/mh
        mw*=a
        mh*=a

    miniature.src = url
    miniature.style.height = "#{mh}px"
    miniature.style.width = "#{mw}px"

    a = h/w
    w = @dom.width()
    h = w*a
    #dh = @dom.height()
    #if h > dh
    #  h = dh
    #  w = dh/a
    whide = @photos.find '.block'
    Feel.pbar.set()
    thenf = =>
      Feel.pbar.set()
      console.log 'load'
      whide.animate({'opacity':0},500)
      setTimeout =>
        Feel.pbar.stop()
        console.log 'pbar.stop'
        whide.filter('.photo').remove()
        whide.filter('.unknown').hide()
        if url
          @photos.css {width : w,height:h}
          img.show 0, =>
            img.animate {opacity:1}, 500, @enable_loader
        else
          @photos.css {width:w,height:@found.unknown.height()}
          @found.unknown.show 0, =>
            @found.unknown.animate {opacity:1}, 500, @enable_loader
      ,500
    if url
      img = $ "<div class='block photo'><img src='#{url}' width='100%' /></div>"
      .hide()
      img.css 'opacity',0
      img.appendTo @photos
      img.find('img').on 'load',thenf
    else
      thenf()

@main = AddPhotos

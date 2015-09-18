



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
    @found.remove_photo.click @remove_photo.out
  remove_photo : =>
    return unless @found.photos.find('>.photo').length
    yield @$send 'removeAva'
    $.getJSON('/uploaded/image')
    .success (data)=>
      @setPhoto data.url,data.width,data.height
    .error (err)=>
      console.error err
  done : (e,data)=>
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
    #d = yield Feel.json '/uploaded', data
    #@log d
    @resetInput()
  resetInput : =>
    @dom.find('input').remove()
    @found.input_wrap.append @input=$('<input accept="image/*" type="file" name="files[]" data-url="/upload/image" multiple="" class="input" />')
    @input.fileupload
      dataType : 'json'
      done : @done
      #maxChunkSize : 10
      #multipart : true
      #progressInterval : 10
      #bitrateInterval : 100
      #seqentialUploads : true
      #singleFileUploads : false
      #processData : true
      progressall : @progressall
      progress : @start
      #progress : @progressone.out
      #start : @start.out
      start: @start
    @input.on 'change', @start
  start : (e,data)=>
    console.log 'start'
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
    a = h/w
    w = @dom.width()
    h = w*a
    dh = @dom.height()
    #if h > dh
    #  h = dh
    #  w = dh/a
    whide = @found.photos.find '.block'
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
          @found.photos.css {width : w,height:h}
          img.show()
          img.animate({opacity:1},500)
        else
          @found.photos.css {width:w,height:@found.unknown.height()}
          @found.unknown.show()
          @found.unknown.animate {opacity:1},500
      ,500
    if url
      img = $ "<div class='block photo'><img src='#{url}' width='100%' /></div>"
      img.hide()
      img.css 'opacity',0
      img.appendTo @found.photos
      img.find('img').on 'load',thenf
    else
      thenf()

@main = AddPhotos

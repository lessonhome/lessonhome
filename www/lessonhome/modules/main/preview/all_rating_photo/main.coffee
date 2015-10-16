class @main extends EE
  Dom:  =>
    @photo        = @dom.find('>.photo')#@found.photo
    @img          = @photo.children 'img'
    @count_review = @found.count_review
    @tree.value ?= {}
    @tree.value.photos ?= []
  W :=>
    w = @photo.width()
    unless w
      switch @tree.selector
        when 'jump_visit_card'
          w = 108
        else
          w = 132
    return w
  show: =>
    @photo.on 'click', =>
      @closing = false
      @next() if @photo.hasClass('hover') || @small
      return if @closing
      @photo.addClass 'hover'
      @photo.css 'z-index',101
      Feel.popupAdd @photo,@closePhoto
  closePhoto : =>
    @closing = true
    @photo.removeClass 'hover'
    @photo.css 'z-index',100
    @small = true
  setValue : (value={})=>
    @tree.all_rating.class.setValue rating:value?.rating
    @tree.value ?= {}
    @tree.value[key] = val for key,val of value
    @tree.value.photos ?= []
    value = @tree.value
    if @tree.cost && @tree.value.left_price
      @found.cost.text @tree.value.left_price
    @leng = value.photos.length
    @now  = @leng-1
    @small = true
    photo = value.photos[@now]
    @first = photo
    h = photo.lheight*@W()/photo.lwidth
    w = @W()
    @photo.height h
    if photo?.lurl?.match? /unknown\.photo\.gif/
      @photo.addClass 'unknown'
    else
      @photo.removeClass 'unknown'
    @img.attr   'src'   , photo.lurl
    #@img.attr   'width' , "100%"
    #@img.attr   'height', "100%"
    do => Q.spawn =>
      link = '/tutor_profile?'+yield Feel.udata.d2u('tutorProfile',{index:@tree.value.index,inset:2})
      @dom.find('a').attr 'href',link
    ###
    @photo.on 'mouseover', =>
      @photo.css 'z-index',101
      #@photo.off 'mouseover'
      @loadHigh()
    @photo.on 'mouseleave',=>
      @photo.css 'z-index',100
    ###
  loadHigh : =>
    return if @loadingHigh
    @loadingHigh = true
    img = $('<img></img>')
    img.attr 'src',@first.hurl
    #img.attr   'width' , "100%"
    #img.attr   'height', "100%"
    img.css {
      "z-index" : 2
      opacity : 0
    }
    img.appendTo @photo
    img.on 'load',=>
      img.animate {opacity:1},1000
  next : =>
    @old = @now
    unless @small
      @now--
      if @now < 0
        @now = @leng - 1
        @closePhoto()
      return @closePhoto() if @old == @now
    @small = false
    photo = @tree.value.photos[@now]
    @changePhoto photo
    
    

  changePhoto : (photo)=>
    img = $('<img></img>')
    img.attr 'src',photo.hurl
    #img.attr   'width' , "132px"
    h = photo.lheight*@W()/photo.lwidth
    img.css {
      "z-index" : 2
      opacity : 0
    }
    imgs = @photo.find 'img'
    img.appendTo @photo
    img.on 'load',=>
      @photo.css {height:h}
      img.css {opacity:1}
      imgs.remove()

  getValue : => @getData()

  getData : => @tree.value

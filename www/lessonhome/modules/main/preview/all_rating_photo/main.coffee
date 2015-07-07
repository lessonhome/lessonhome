class @main extends EE
  Dom:  =>

    @photo        = @dom.find('>.photo')#@found.photo
    @img          = @photo.children 'img'
    @count_review = @found.count_review

  show: =>

  setValue : (value={})=>
    @tree.all_rating.class.setValue rating:value?.rating
    @tree.value ?= {}
    @tree.value[key] = val for key,val of value
    value = @tree.value
    W = 130 #@photo.width()
    value.photos ?= []
    photo = value.photos[value.photos.length-1]
    @first = photo
    h = photo.lheight*W/photo.lwidth
    w = W
    
    @photo.height h
    @img.attr   'src'   , photo.lurl
    @img.attr   'width' , "100%"
    @img.attr   'height', "100%"
    @photo.on 'mouseenter', =>
      @photo.off 'mouseenter'
      @loadHigh()
  loadHigh : =>
    img = $('<img></img>')
    img.attr 'src',@first.hurl
    img.attr   'width' , "100%"
    img.attr   'height', "100%"
    img.css {
      "z-index" : 2
      opacity : 0
    }
    img.appendTo @photo
    img.on 'load',=>
      img.animate {opacity:1},1000


  getValue : => @getData()

  getData : => @tree.value

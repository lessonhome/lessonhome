class @main extends EE
  Dom:  =>
    @dom.click (e)=> Q.spawn =>
      if e.ctrlKey && e.altKey && @index > 0
        yield Feel.root.tree.class.$send '/relogin',@index
        yield Feel.go '/form/tutor/login',true
  show: =>
    @rating_photo   = @tree.rating_photo.class
    @tutor_extract  = @tree.tutor_extract.class
    #@set
  setValue : (data)=>
    @index = data?.index ? 0
    @rating_photo.setValue {
      #rating : data.rating
      index : data.index
      photos : data.photos
      price_per_hour : data.price_per_hour
      count_review : data.count_review
    }
    @tutor_extract.setValue data
  getData : =>
    rpv = @rating_photo.getValue()
    texv = @tutor_extract.getValue()
    texv[key] = val for key,val of rpv
    return texv



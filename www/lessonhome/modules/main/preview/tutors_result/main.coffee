class @main extends EE
  Dom:  =>
    @dom.click (e)=> Q.spawn =>
      if e.ctrlKey && e.altKey && @index > 0
        yield @$send '/relogin',@index
        Feel.go '/form/tutor/login'
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
      count_review : data.count_review
    }
    @tutor_extract.setValue data
  getData : =>
    rpv = @rating_photo.getValue()
    texv = @tutor_extract.getValue()
    texv[key] = val for key,val of rpv
    return texv



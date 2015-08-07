class @main extends EE
  Dom:  =>
  show: =>
    @rating_photo   = @tree.rating_photo.class
    @tutor_extract  = @tree.tutor_extract.class
    #@set
  setValue : (data)=>
    @rating_photo.setValue {
      rating : data.rating
      photos : data.photos
      count_review : data.count_review
    }
    @tutor_extract.setValue data
  getData : =>
    rpv = @rating_photo.getValue()
    texv = @tutor_extract.getValue()
    texv[key] = val for key,val of rpv
    return texv



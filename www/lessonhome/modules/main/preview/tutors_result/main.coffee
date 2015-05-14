class @main extends EE
  Dom:  =>
  show: =>
    @rating_photo   = @tree.rating_photo.class
    @tutor_extract  = @tree.tutor_extract.class

  setValue : (data)=>



  getData : =>
    rpv = @rating_photo.getValue()
    texv = @tutor_extract.getValue()
    return {
      #rating
      image             : rpv.image
      count_review      : rpv.count_review
      #extract
      tutor_name        : texv.tutor_name
      with_verification : texv.with_verification
      tutor_subject     : texv.tutor_subject
      tutor_status      : texv.tutor_status
      tutor_exp         : texv.tutor_exp
      tutor_place       : texv.tutor_place
      tutor_title       : texv.tutor_title
      tutor_text        : texv.tutor_text
      tutor_price       : texv.tutor_price
    }



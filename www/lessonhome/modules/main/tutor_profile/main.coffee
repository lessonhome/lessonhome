
class @main
  Dom: =>
    @back = @found.back
  show: =>
    $(@back).click => @goBack()
  goBack: =>
    document.location.href = window.history.back()
  setValue : (data)=>


    @rating_photo.setValue {
      rating : data.rating
      photos : data.photos
      count_review : data.count_review
    }
    @tutor_extract.setValue data
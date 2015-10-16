class @main extends EE
  Dom:  =>
    @dom.dblclick => Q.spawn =>
      yield Feel.root.tree.class.$send '/relogin',@index
      yield Feel.go '/form/tutor/login',true

    @dom.click (e)=> Q.spawn =>
      if e.ctrlKey && e.altKey && @index > 0
        yield Feel.root.tree.class.$send '/relogin',@index
        yield Feel.go '/form/tutor/login',true
      if !e.ctrlKey && !e.altKey && e.shiftKey
        yield @$send './ratingAva','up',@index
      else if (!e.ctrlKey) && e.altKey && e.shiftKey
        yield @$send './ratingAva','down',@index

  show: =>
    @rating_photo   = @tree.rating_photo.class
    @tutor_extract  = @tree.tutor_extract.class
    if @tree.onepage
      do (that=this)=> @dom.find('a').click (e)->
        return unless e.button == 0
        e.preventDefault()
        Feel.root.tree.class.showTutor that.index,$(this).attr('href')
        return false
  setValue : (data)=>
    @index = data?.index ? 0
    @rating_photo.setValue {
      rating : data.rating
      index : data.index
      photos : data.photos
      price_per_hour : data.price_per_hour
      left_price : data.left_price
      count_review : data.count_review
    }
    @tutor_extract.setValue data
  getData : =>
    rpv = @rating_photo.getValue()
    texv = @tutor_extract.getValue()
    texv[key] = val for key,val of rpv
    return texv



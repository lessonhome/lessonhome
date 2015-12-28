class @main extends EE
  Dom:  =>
    @found.right_block.dblclick => Q.spawn =>
      return unless Feel.user?.type?.admin
      yield Feel.root.tree.class.$send '/relogin',@index
      yield Feel.go '/form/tutor/login',true

    @dom.click (e)=> Q.spawn =>
      return unless Feel.user?.type?.admin
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
    if Feel.user.type.admin
      console.log data
      @found.mcomment.val data.mcomment
      @found.ratio.text "#{data.rating?.toFixed?(2)} - #{data.ratio?.toFixed?(2)} - #{data.ratingNow?.toFixed?(0)}"
      if data.landing
        @found.lp.addClass 'red'
      if data.checked
        @found.checked.addClass 'red'
      if data.filtration
        @found.filter.addClass 'red'

      @found.rdown.click =>
        data.ratingNow /= 1.1
        data.ratio /= 1.1
        @found.ratio.text "#{data.rating?.toFixed?(2)} - #{data.ratio?.toFixed?(2)} - #{data.ratingNow?.toFixed?(0)}"
        @$send './ratingAva','ratio',@index,data.ratio
      @found.rup.click =>
        data.ratingNow *= 1.1
        data.ratio *= 1.1
        @found.ratio.text "#{data.rating?.toFixed?(2)} - #{data.ratio?.toFixed?(2)} - #{data.ratingNow?.toFixed?(0)}"
        @$send './ratingAva','ratio',@index,data.ratio
      @found.lp.click =>
        @found.lp.toggleClass 'red'
        @$send './ratingAva','landing',   @index,@found.lp.hasClass('red')
      @found.checked.click =>
        @found.checked.toggleClass 'red'
        @$send './ratingAva','checked',   @index,@found.checked.hasClass('red')
      @found.filter.click =>
        @found.filter.toggleClass 'red'
        @$send './ratingAva','filtration',@index,@found.filter.hasClass('red')
      @found.mcomment.focusout =>
        @$send './ratingAva','mcomment',@index,@found.mcomment.val()
  getData : =>
    rpv = @rating_photo.getValue()
    texv = @tutor_extract.getValue()
    texv[key] = val for key,val of rpv
    return texv



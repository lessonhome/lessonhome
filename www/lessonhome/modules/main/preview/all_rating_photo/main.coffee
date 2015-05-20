class @main extends EE
  Dom:  =>

    @photo        = @dom.find('>.photo')#@found.photo
    @img          = @photo.children 'img'
    @count_review = @found.count_review

  show: =>

  setValue : (value) =>
    @photo.css  'width', value.w if value?.w?
    @photo.css  'height', value.h if value?.h?
    @img.attr   'src'   , value.src if value?.src?
    @img.attr   'width' , value.w   if value?.w?
    @img.attr   'height', value.h   if value?.h?



  getValue : => @getData()

  getData : =>
    return {
      image         :
        src : @img.attr 'src'
        h   : @img.attr 'height'
        w   : @img.attr 'width'
      count_review  : @tree.count_review
    }
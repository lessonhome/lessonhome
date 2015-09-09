



class AddPhotos
  constructor : ->
    Wrap @
  Dom : =>
    @input = @found.input
    @photos = document.getElementsByClassName('photo1')
  show : =>
    console.log @input
    @input.fileupload
      dataType : 'json'
      done : @done.out
  done : (e,data)=>
    $.getJSON('/uploaded/image', {avatar:'false'})
    .success (data)=>
      console.log 'data', data.uploaded
      console.log 'success'
      for photo in data.uploaded
        unless photo.hash.match(/low|high/)
          newPhoto = document.createElement('div')
          newPhoto.className = 'photo1'
          @photos[0].parentElement.insertBefore(newPhoto, @photos[0])
          @photos = document.getElementsByClassName('photo1')
          newImg = document.createElement('img')
          newImg.src = photo.url
          newImg.style.width = '100%'
          newImg.style. height = '100%'
          newImg.style.opacity = 0
          @photos[0].appendChild(newImg)
          $("img[src$='#{photo.url}']").animate({opacity:1}, 500)
    .error (err)=>
      console.error err

@main = AddPhotos

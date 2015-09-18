



class AddPhotos
  constructor : ->
    Wrap @
  Dom : =>
    @input = @found.input
    @photos = document.getElementsByClassName('photo1')
  show : =>
    @input.fileupload
      dataType : 'json'
      done : @done.out
  done : (e,data)=>
    $.getJSON('/uploaded/image', {avatar:'false'})
    .success (data)=>
      if data?.uploaded?
        photos = []
        for photo in data.uploaded
          photos.push photo unless photo.hash.match(/low|high/)
        @emit 'uploaded', photos.reverse()
        console.log 'success'
    .error (err)=>
      console.error err
@main = AddPhotos

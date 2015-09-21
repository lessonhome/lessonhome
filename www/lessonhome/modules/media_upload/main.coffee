



class AddPhotos
  constructor : ->
    Wrap @
  Dom : =>
    @input = @found.input
    @photos = document.getElementsByClassName('photo1')

  show : =>
    @input.fileupload
      dataType : 'json'
      progressall : @progressall.out
      done : @done.out
      change : (e)=>
        @input = $(e.target)
        @input.prop 'disabled',true
        
  done : (e,data)=>
    nowFile   = data?.files[data?.files?.length-1]
    lastFile  = data?.originalFiles?[data?.originalFiles?.length-1]
    return unless nowFile==lastFile
    $.getJSON('/uploaded/image', {avatar:'false'})
    .success (data)=>
      if data?.uploaded?
        photos = []
        for photo in data.uploaded
          photos.push photo unless photo.hash.match(/low|high/)
        @emit 'uploaded', photos.reverse()
        console.log 'success'
    .done (data)=>
      Feel.pbar.stop()
      console.log 'done'
      @input.prop 'disabled',false
    .error (err)=>
      console.error err
  progressall : (e,data)=>
    Feel.pbar.set data.loaded*0.5/data.total
@main = AddPhotos

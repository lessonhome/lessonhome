



class AddPhotos
  constructor : ->
    $W @
  Dom : =>
    @input = @found.input
    @type = @tree.type
    console.log @tree.photos
  show : =>
    @params = {}
    @params[@type] = 'true'
    @input.fileupload
      dataType : 'json'
      singleFileUploads: false
      progressall : @progressall
      done : @done
      change : (e)=>
        @input = $(e.target)
        @input.prop 'disabled',true
        
  done : (e,data)=>
#    nowFile   = data?.files[data?.files?.length-1]
#    lastFile  = data?.originalFiles?[data?.originalFiles?.length-1]
#    return unless nowFile==lastFile
    $.getJSON('/uploaded/image', @params)
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

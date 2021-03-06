



class AddPhotos
  constructor : ->
    $W @
  Dom : =>
    @input = @found.input
    @type = @tree.type
    console.log @tree.photos

  initUploaded : (dropZone) =>
    dropZone.on 'click', => @input.trigger('click')
    @params = {}
    @params[@type] = 'true'
    @input.fileupload
      dropZone : dropZone
      dataType : 'json'
      singleFileUploads: false
      progressall : @progressall
      done : @done
      change : (e)=>
        @input = $(e.target)
        @input.prop 'disabled',true
      fail : ->
        Feel.sendAction 'error_on_page'

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
      Feel.sendAction 'error_on_page'
  progressall : (e,data)=>
    Feel.pbar.set data.loaded*0.5/data.total
@main = AddPhotos



class @main
  constructor : ->
    $W @
  show : =>
    @input_photo = @tree.line_med.upload_input.class
    @input_doc = @tree.line_doc.upload_input.class
    @add_photos = @tree.photo.class
    @media = @tree.media.class
    @doc = @tree.documents.class

    @input_photo.on 'uploaded', (photo)=> @media.add photo
    @input_doc.on 'uploaded', (photo)=> @doc.add photo
#    @add_photos.on 'uploaded', (photo)=> @media.add photo

#    @media.on 'select', (photo) =>
#      console.log 'ava'
#      @add_photos.setPhoto(photo.url, photo.width, photo.height)

    @media.on 'remove', (hash)=>
      result = yield @$send('removeMedia', {hash: hash})
      if result.status == "success" then @media.remove_photo(hash)

    @doc.on 'remove', (hash)=>
      result = yield @$send('removeMedia', {hash: hash, type: 'documents'} )
      if result.status == "success" then @doc.remove_photo(hash)
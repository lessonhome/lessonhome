

class @main
  constructor : ->
    $W @
  show : =>
    @input_photo = @tree.line_med.upload_input.class
    @input_doc = @tree.line_doc.upload_input.class
    @input_avatars = @tree.line_avatars?.upload_input?.class
    @add_photos = @tree.photo.class
    @media = @tree.media.class
    @doc = @tree.documents.class
    @avatars = @tree.avatars?.class

    @input_photo.initUploaded @media.drop_zone
    @input_doc.initUploaded @doc.drop_zone
    @input_avatars.initUploaded @avatars.drop_zone

    $(document).bind 'drop dragover', (e)-> e.preventDefault()
    $(document).bind 'dragover', (e)=>
      @avatars.openZone()
      @media.openZone()
      @doc.openZone()

    @input_avatars.on 'uploaded', (photo)=>@avatars.add photo
    @input_photo.on 'uploaded', (photo)=>@media.add photo
    @input_doc.on 'uploaded', (photo)=>@doc.add photo


#    @add_photos.on 'uploaded', (photo)=> @media.add photo

#    @media.on 'select', (photo) =>
#      console.log 'ava'
#      @add_photos.setPhoto(photo.url, photo.width, photo.height)

    onselect = (hash)=> Q.spawn =>
      data = yield @$send('setAvatar', {id: hash})
      if data.status == 'success'
        $('html, body').animate {scrollTop: @dom.offset().top}, 250
        data = data.newAva
        return unless data.url? and data.width? and data.height?

        @add_photos.setPhoto data.url, data.width, data.height
    @media.on 'select', onselect
    @avatars.on 'select', onselect

    @media.on 'remove', (hash)=>
      result = yield @$send('removeMedia', {hash: hash})
      if result.status == "success" then @media.remove_photo(hash)

    @doc.on 'remove', (hash)=>
      result = yield @$send('removeMedia', {hash: hash, type: 'documents'} )
      if result.status == "success" then @doc.remove_photo(hash)
    @avatars.on 'remove', (hash)=>
      result = yield @$send('removeMedia', {hash: hash, type: 'avatars'} )
      if result.status == "success" then @avatars.remove_photo(hash)



class @main
  constructor : ->
    Wrap @
  show : =>
    @input = @tree.line_med.upload_input.class
    @add_photos = @tree.photo.class
    @media = @tree.media.class

    @input.on 'uploaded', (photo)=> @media.add photo
    @add_photos.on 'uploaded', (photo)=> @media.add photo
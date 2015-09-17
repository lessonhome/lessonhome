


class media
  constructor : ->
    Wrap @
  Dom : =>
    @remove_buttons = document.getElementsByClassName('remove')

    for button in @remove_buttons
      button.onclick = @delete_photo
  show : =>
  delete_photo: ->
    
@main = media
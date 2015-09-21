


class media
  constructor : ->
    Wrap @
  Dom : =>
    @setRemoveHandlers()
    @setAvaHandlers()

  show : =>

    @photos = {}
    for i, layer of @tree.photos
      for j, photo of layer.photos
        @photos[photo.hash] = photo

  reloadPhotos: (photos) =>

    layers = yield @remakeLayers(photos)

    media_content = document.getElementById('m-tutor-profile_content-media')

    media_content.removeChild(media_content.lastChild) while media_content.lastChild

    for layer in layers
      layerDOM = document.createElement('div')
      layerDOM.className = 'photo1'
      layerDOM.style.height = layer.height+'px'
      for photo in layer.photos
        wrapper = document.createElement('div')
        wrapper.id = 'wrapper-'+photo.hash
        wrapper.style.left = photo.left+'px'
        remove = document.createElement('div')
        remove.className = 'remove'
        image = document.createElement('img')
        image.id = photo.hash
        image.className = 'big'
        image.src = photo.url

        wrapper.appendChild(remove)
        wrapper.appendChild(image)
        layerDOM.appendChild(wrapper)

      media_content.appendChild(layerDOM)

    @setRemoveHandlers()
    @setAvaHandlers()

  remove_photo: (id) =>

    yield @$send('removeMedia', {hash: id})
    delete @photos[id]

    photos_left = []

    for hash, photo of @photos
      photos_left.push photo

    @reloadPhotos(photos_left)

  add : (image) =>

    if image.push?
      photos = image
    else
      photos = [image]

    for hash, photo of @photos
      photos.push photo

    @photos = {}
    for photo in photos
      @photos[photo.hash] = photo

    @reloadPhotos(photos)


  setRemoveHandlers: =>
    @remove_buttons = document.getElementsByClassName('remove')

    remove = @remove_photo

    for button in @remove_buttons
      button.onclick = () ->
        remove(this.nextSibling.id)

  setAvaHandlers: =>
    @images = document.getElementsByClassName('big')
    photos = @photos
    setAsAvatar = @setAsAvatar

    for image in @images
      image.onclick = () ->
        setAsAvatar(this.id)

  setAsAvatar: (id)=>
    @$send('setAvatar', {id: id})
    .then (data)=>
      @emit 'set_ava', data.newAva
  remakeLayers: (photos) =>
    W = 738
    HMIN = 150
    HMAX = 350
    d = 5
    layers = []
    layer = undefined
    a = 0
    n = 0

    for p in photos
      continue unless p
      unless layer
        a = 0
        layer = {
          photos : []
        }
      na = a + p.width/p.height
      nn = n+1
      nh = (W-nn*2*d)/na
      if (nh>HMIN) || (nn<=1)
        layer.photos.push p
        if nh > HMAX
          nh = HMAX
        layer.height = nh
        n = nn
        a = na
      else
        layers.push layer
        a = (p.width/p.height)
        n = 1
        layer = {
          height : (W-2*d)/a
          photos : [p]
        }
        if layer.height > HMAX
          layer.height = HMAX
    layers.push layer if layer
    for layer in layers
      shift = 0
      for p,i in layer.photos
        p.left = shift + d
        shift += p.width*layer.height/p.height+d*2
    return layers

@main = media
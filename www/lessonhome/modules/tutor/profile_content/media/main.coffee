


class media
  constructor : ->
    $W @
  show : =>
    @photos = {}
    for i, layer of @tree.photos
      for j, photo of layer.photos
        @photos[photo.hash] = photo
    console.log @photos
    @dom.on 'click', '.remove',  (e) =>
      @emit 'remove', $(e.currentTarget).closest('.photo-wrap').attr('data-id')

  reloadPhotos: (photos) =>

    layers = yield @remakeLayers(photos)

    media_content = @dom[0]

    media_content.removeChild(media_content.lastChild) while media_content.lastChild

    for layer in layers
      layerDOM = document.createElement('div')
      layerDOM.className = 'photo1'
      layerDOM.style.height = layer.height+'px'
      for photo in layer.photos
        wrapper = document.createElement('div')
        wrapper.className = 'photo-wrap'
        wrapper.setAttribute('data-id', photo.hash)
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

  remove_photo: (id) =>

#    yield @$send('removeMedia', {hash: id})
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

  setAsAvatar: (id)=> do Q.async =>
#    data = yield @$send('setAvatar', {id: id})
#    @emit 'set_ava', data.newAva
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

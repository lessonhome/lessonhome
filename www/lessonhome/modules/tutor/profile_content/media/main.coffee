


class media
  constructor : ->
    $W @
  Dom : =>
    @drop_zone = @found.drop_zone
    @timeout_zone = null
    @visible_zone = @drop_zone.is ':visible'
  show : =>
    @photos = {}
    for i, layer of @tree.photos
      for j, photo of layer.photos
        @photos[photo.hash] = photo

    @dom.on 'click', '.remove',  (e) =>
      @emit 'remove', $(e.currentTarget).closest('.photo-wrap').attr('data-id')
      e.stopPropagation()

    if @tree.message
      @dom.on 'click', '.photo-wrap', (e) =>
        @emit 'select', $(e.currentTarget).attr('data-id')

  openZone : =>
    if @timeout_zone
      clearTimeout(@timeout_zone)
    @drop_zone.fadeIn() unless @drop_zone.is ':visible' and @visible_zone
    @timeout_zone = setTimeout =>
      @timeout_zone = null
      @drop_zone.fadeOut() unless @visible_zone
    , 800

  reloadPhotos: () =>
    layers = yield @remakeLayers()
    media_content = @found.content[0]
    if layers.length
      @drop_zone.fadeOut =>
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
            if @tree.message
              div = document.createElement('div')
              div.className = 'load-text'
              div.innerHTML = @tree.message
              wrapper.className += ' ' + 'pointer'
              wrapper.appendChild(div)
            layerDOM.appendChild(wrapper)

          media_content.appendChild(layerDOM)
      @visible_zone = false
    else
      media_content.removeChild(media_content.lastChild) while media_content.lastChild
      @drop_zone.fadeIn()
      @visible_zone = true


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

    @reloadPhotos()

  setAsAvatar: (id)=> do Q.async =>
#    data = yield @$send('setAvatar', {id: id})
#    @emit 'set_ava', data.newAva
  remakeLayers: () =>
    W = 738
    HMIN = 150
    HMAX = 350
    d = 5
    layers = []
    layer = undefined
    a = 0
    n = 0

    for hash, p of @photos
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

class @main
  constructor: ->
    $W @
  Dom: =>
    @val = @tree.value.filter
    @tags = @found.tags_filter
    @templ_b =  @tags.find('.templ').clone().children()
    @templ_n = @templ_b.find('span')
  show : =>
    @tags.on 'click', '.chip.active', @onClickTag

  onClickTag : (e) =>
    el = $(e.currentTarget)
    el.removeClass('active').find('i').trigger('click')
    val = el.attr('data-v')
    belong = el.attr('data-b')
    switch belong
      when 'subjects', 'course'
        @val[belong].splice(@val[belong].indexOf(val),1)
      when 'price', 'status'
        @val[belong][val] = false
      when 'sex'
        @val[belong] = @tree.sex.items[0]
    Q.spawn => yield Feel.urlData.set 'tutorsFilter', @val

  getTag: (name) ->
    @templ_n.text(name)
    return @templ_b.clone().attr('data-v', name)

  getValue: ->

  setValue: (value) ->
    value = value.filter || {}
    @val = value
    frag = $(document.createDocumentFragment())

    frag.append( @getTag(s).attr('data-b', 'subjects') ) for s in value.subjects
    frag.append( @getTag(s).attr('data-b', 'course') ) for s in value.course
    frag.append( @getTag(s).attr('data-b', 'price') ) for s,v of value.price when v
    frag.append( @getTag(s).attr('data-b', 'status') ) for s,v of value.status when v
    if value.sex != @tree.sex.items[0]
      frag.append(@getTag(value.sex).attr('data-b', 'sex'))
    @tags.html('').append(frag)


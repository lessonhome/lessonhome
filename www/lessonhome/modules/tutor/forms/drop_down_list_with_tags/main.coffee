
class @main extends EE
  Dom : =>
    @list = @tree.list.class
    @tags = @found.tags
    @tag  = @found.tag

  show : =>
    @list.on 'end', => @addTag()
    @list.on 'press_enter', => @addTag()
    @closeHandler()

  ####### TAGS FUNCTIONS
  addTag: (tag_text,update=true)=>
    tags_arr = @getTags()
    tag_text ?= @list.getValue()
    return if !tag_text
    @list.setValue('')
    if tags_arr.length
      for val in tags_arr
        if tag_text == val then return 0
    new_tag = $(@tag).clone()
    new_tag.find(".text").text(tag_text)
    new_tag.find(".close_box").click =>
      new_tag.remove()
      @emit 'change'
      @emit 'end'
    $(@tags).append(new_tag)
    if update
      @emit 'change'
      @emit 'end'
  getTags: =>
    data = []
    children = $(@tags).children()
    for child in children
      child = $ child
      data.push child.find(".text").text()
    return data
  setValue : (list)=>
    @list.setValue ''
    list ?= @tree?.default
    list = [] unless list && typeof list == 'object'
    children = $(@tags).children()
    for child in children
      child = $ child
      child.remove()
    for i,tag of list
      @addTag tag,false
    @emit 'change'
    @emit 'end'

  reset : =>
    @list.setValue('')
    children = $(@tags).children()
    for child in children
      child = $ child
      child.remove()
    @emit 'change'
    @emit 'end'
  closeHandler: =>
    children = $(@tags).children()
    for child in children
      do (child)=>
        child = $ child
        cb = child.find(".close_box")
        cb.off()
        cb.click =>
          child.remove()
          @emit 'change'
          @emit 'end'
        

  getValue : => @getTags()



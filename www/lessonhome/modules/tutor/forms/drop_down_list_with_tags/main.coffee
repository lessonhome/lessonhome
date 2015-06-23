
class @main extends EE
  Dom : =>
    @list = @tree.list.class
    @tags = @found.tags
    @tag  = @found.tag

  show : =>
    console.log 'this is list'
    console.log @list
    console.log 'this is list'
    @list.on 'end', => @addTag()
    @list.on 'press_enter', => @addTag()
    @closeHandler()

  ####### TAGS FUNCTIONS
  addTag: =>
    tags_arr = @getTags()
    tag_text = @list.getValue()
    return if !tag_text
    @list.setValue('')
    if tags_arr.length
      for val in tags_arr
        if tag_text == val then return 0
    new_tag = $(@tag).clone()
    console.log 'new_tag '+new_tag
    new_tag.find(".text").text(tag_text)
    new_tag.find(".close_box").click( =>
      new_tag.remove()
      @emit 'change'
      @emit 'end'
    )
    console.log 'this is new_tag'
    console.log new_tag
    $(@tags).append(new_tag)
    @emit 'change'
    @emit 'end'
  getTags: =>
    data = []
    children = $(@tags).children()
    for child in children
      child = $ child
      data.push child.find(".text").text()
    return data
  cleanForm : =>
    @list.setValue('')
    children = $(@tags).children()
    for child in children
      child = $ child
      child.remove()
  closeHandler: =>
    children = $(@tags).children()
    for child in children
      do (child)=>
        child = $ child
        child.find(".close_box").click( =>
          child.remove()
        )

  getValue : => @getTags()



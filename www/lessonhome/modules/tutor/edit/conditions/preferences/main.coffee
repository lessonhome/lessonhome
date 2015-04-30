
class @main extends EE
  Dom : =>
    @area_tags_div  = @found.area_tags
    @tag   = @found.tag
    @area  = @tree.area.class
  show : =>
    @area.on 'end', => @addTag @getTags(), @area_tags_div, @area.getValue()
    @closeHandler()
  save : => Q().then =>
    if @check_form()
      return @$send('./save',@getData())
      .then ({status,errs})=>
        if status=='success'
          return true
        #if errs?.length
        #@parseError errs
        return false
    else
      return false

  addTag: (tags_arr, tags_div, tag_text)=>
    return if !tag_text
    if tags_arr.length
      for val in tags_arr
        if tag_text == val then return 0
    new_tag = $(@tag).clone()
    new_tag.find(".text").text(tag_text)
    new_tag.find(".close_box").click( =>
      new_tag.remove()
    )
    $(tags_div).append(new_tag)

  getData: =>
    return {
      area_tags:  @getTags()
    }

  check_form: => true

  getTags: =>
    data = []
    children = $(@area_tags_div).children()
    for child in children
      child = $ child
      data.push child.find(".text").text()
    console.log 'data : '+data, children
    return data

  closeHandler: =>
    children = $(@area_tags_div).children()
    for child in children
      do (child)=>
        child = $ child
        child.find(".close_box").click( =>
          child.remove()
        )
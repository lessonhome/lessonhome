
class @main
  Dom: =>
    @title = @found.title
    @value = @found.value
    @section = @tree.section.class

  setValue: (data)=>
    i=0
    for val, key of data
      @title[i++].text(key)
      @value[i++].text(val)


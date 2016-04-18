class @main extends EE
  Dom : =>
    @select = @found.select
    @select.material_select()
    @select.on 'change',=> @emit 'change'
  val : (value) =>
    if value
      arr = {}
      for v in value ? []
        arr[v] = true
      value = Object.keys(arr)
      value.sort()
      return @select.val(value)
    value =  @select.val()
    arr = {}
    for v in value ? []
      arr[v] = true
    value = Object.keys(arr)
    value.sort()
    return value
    
  setValue : (value) =>
    @select.val()
    @val(value).trigger('update')
  getValue : => @val()

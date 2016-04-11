class @main extends EE
  Dom : =>
    @select = @found.select
    @select.material_select()
  val : (value) => return if value? then @select.val(value) else @select.val()
  setValue : (value) => @val(value).trigger('update')
  getValue : => @val()
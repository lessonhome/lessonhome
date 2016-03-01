class @main
  Dom : =>
    @short_form = @tree.short_attach.class
  show: =>
    @short_form.setListener()

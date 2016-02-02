class @main
  remove : =>
    @dom.parent().remove()
    @removed = true
  show : =>
    @found.remove_button.click =>
      @remove()
      @emit 'change'
    @tree.place_of_work.class.on 'end',=> @emit 'change'
    @tree.post.class.on 'end',=> @emit 'change'
  getValue : =>
    place : @tree.place_of_work.class.getValue()
    post          : @tree.post.class.getValue()
  setValue : (data={})=>
    @tree.place_of_work.class.setValue data.place || ""
    @tree.post.class.setValue data.post || ""

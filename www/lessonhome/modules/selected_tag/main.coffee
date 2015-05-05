class @main extends EE
  show: =>
    @selected_tag = @dom.find(".selected_tag")
    @selected_tag_id = @selected_tag.attr('id')
    @close_button = @selected_tag.find (".close")
    @delete_control()

  delete_control: =>
    @close_button.on 'click', => @close_button_click()


  close_button_click: =>
    @dom.parent().remove()
    console.log 'send req by id ' +  @selected_tag_id


  getValue: => @tree.text


###
5. selected_tag:
функция создания модуля
функция удаления из базы данных
функция добавления в базу данных
функция удаления со страницы
###

class @main
  Dom: =>
    @hide_el      = @found.hide
    @del          = @found.delete
    @container    = @found.container
    @bg_block     = @found.bg_block

    @out_err_course         = @found.out_err_course
    #@out_err_qualification  = @found.out_err_qualification
    @out_err_group_learning = @found.out_err_group_learning
    @out_err_categories_of_students = @found.out_err_categories_of_students
    @out_err_place = @found.out_err_place
    #@out_err_group_learning = @found.out_err_group_learning

  show: =>
    @hide_el.on 'click', =>
      text = @hide_el.text()
      if text == 'Свернуть'
        @container.hide()
        text = @hide_el.text('Развернуть')
      if text == 'Развернуть'
        @container.show()
        text = @hide_el.text('Свернуть')
    @del.on 'click', =>
      @bg_block.remove()

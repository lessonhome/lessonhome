class @main extends EE
  Dom : =>
    @button_back = @tree.button_back.class
    @button_onward = @tree.button_onward.class
    if @tree.list_subject?
      @subject = @tree.list_subject.class
    if @tree.price_slider_top?
      @lesson_price = @tree.price_slider_top.class

  show: =>
    @choose_block = @dom.find('.choose_block')
    #console.log @choose_block
    @i = 2

    ### выходит ошибка на ч-ой странице, subject_tag не определена TODO ###
    #@subject_tag = @tree.choose_subject.class
    @empty_subject_tag = @tree.empty_choose_subject
    #console.log @empty_subject_tag
    #@newSubjectTag()

    @button_onward.on 'submit', =>
      @save()
      @bNext()
    @button_back  .on 'submit', =>
      @save()
      @bBack()

  newSubjectTag: =>
    new_tag = @empty_subject_tag
    new_tag.id = @i++
    new_tag.text = 'new'
    console.log new_tag.class
    @choose_block.append('<div class="choose_button">' + new_tag + '</div>')

  bNext : =>
    @button_onward.submit()

  bBack : =>
    @button_back.submit()

  save : => Q().then =>
    if @check_form()
      return @$send('./save',@getData())
      .then ({status,errs})=>
        if status=='success'
          return true
        if errs?.length
          @parseError errs
        return false
    else
      return false

  getData : =>
    ret = {}
    #console.log ret.subject+' this is ret'
    if @subject? then ret.subject = @subject.getValue()
    if @lesson_price?
      price = []
      price_val = @lesson_price.getValue()
      price.push price_val.left
      price.push price_val.right
      ret.lesson_price = price
    return ret

  check_form : => true




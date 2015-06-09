class @main extends EE
  Dom : =>
    @button_back = @tree.button_back.class
    @button_onward = @tree.button_onward.class
  show: =>
    @choose_block = @dom.find('.choose_block')
    #console.log @choose_block
    @i = 2

    ### выходит ошибка на ч-ой странице, subject_tag не определена TODO ###
    #@subject_tag = @tree.choose_subject.class
    @empty_subject_tag = @tree.empty_choose_subject
    #console.log @empty_subject_tag
    #@newSubjectTag()

    @button_onward.on 'submit', => @bNext()
    @button_back  .on 'submit', => @bBack()

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

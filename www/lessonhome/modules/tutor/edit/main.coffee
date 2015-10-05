
class @main
  Dom : =>
    @changes_field = @found.changes_field
  show : =>
    @save_button = @tree.save_button?.class
    @add_button = @tree.add_button?.class

    #if @tree.tutor_edit?.calendar?.save_button?
      #@save_button = @tree.tutor_edit.calendar.save_button.class
    @tutor_edit = @tree.tutor_edit.class
    #if @tree.tutor_edit?.calendar?
      #@tutor_edit = @tree.tutor_edit.calendar.class
    console.log "tutor_edit : "
    console.log @tree.tutor_edit

    @save_button?.on 'submit', @b_save
    @add_button?.on 'submit', @b_add

  b_save : =>
    console.log 'tree', @tree
    console.log 'found', @tree
    @tutor_edit?.save?().then (success)=>
      console.log 'tutor/edit'
      if success
        ###
        @$send('./save',@progress).then ({status})=>
          if status=='success'
            return true
        ###
        console.log 'IS SEND!!!'
        $('body,html').animate({scrollTop:0}, 500)
        @changes_field.fadeIn(1000)
        return true
    .done()
  b_add : =>
    console.log 'tree',   @tree
    cloned = @tree.tutor_edit.class.$clone()
    rep = cloned.dom
    rep.appendTo('div.tutor_edit')
    rep.css('visibility', 'visible')


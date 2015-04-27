
class @main
  Dom : =>
    @changes_field = @found.changes_field
  show : =>
    @save_button = @tree.save_button?.class
    @tutor_edit = @tree.tutor_edit.class
    if @tree.tutor_edit?.calendar?
      @tutor_edit = @tree.tutor_edit.calendar.class
    @save_button?.on 'submit', @b_save

  b_save : =>
    @tutor_edit?.save?().then (success)=>
      if success
        ###
        @$send('./save',@progress).then ({status})=>
          if status=='success'
            return true
        ###
        $('body,html').animate({scrollTop:0}, 500)
        @changes_field.fadeIn()
        return true
    .done()



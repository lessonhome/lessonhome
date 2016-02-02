

class @main
  Dom : =>
    @changes_field = @found.changes_field
  show : =>
    @save_button = @tree.save_button?.class
    #if @tree.tutor_edit?.calendar?.save_button?
      #@save_button = @tree.tutor_edit.calendar.save_button.class
    @tutor_edit = @tree.tutor_edit.class
    #if @tree.tutor_edit?.calendar?
      #@tutor_edit = @tree.tutor_edit.calendar.class
    console.log "tutor_edit : "
    console.log @tree.tutor_edit
    @save_button?.on 'submit', @b_save

  b_save : => Q.spawn =>
    success = yield @tutor_edit?.save?()
    if success
      $('body,html').animate({scrollTop:0}, 500)
      @changes_field.fadeIn(1000)

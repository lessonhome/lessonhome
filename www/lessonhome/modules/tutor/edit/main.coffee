
class @main
  Dom : =>
    @changes_field = @found.changes_field
  show : =>
    @save_button = @tree.save_button?.class
    @tutor_edit = @tree.tutor_edit.class
    @save_button?.on 'submit', @b_save

  b_save : =>
    @tutor_edit?.save?().then (success)=>
      if success
        ###
        @$send('./save',@progress).then ({status})=>
          if status=='success'
            return true
        ###
        @changes_field.fadeIn()
        return true
    .done()


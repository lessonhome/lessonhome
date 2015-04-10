
class @main
  show : =>
    @bNext = @tree.button_next.class
    @form = @tree.content.form.class
    @progress = @tree.progress_bar.progress
    @bNext.on 'submit', @next
    console.log @progress

  next : =>
    @form?.save?().then (success)=>
      if success
        ###
        @$send('./save',@progress).then ({status})=>
          if status=='success'
            return true
        ###
        @bNext.submit()
    .done()



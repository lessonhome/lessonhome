
class @main
  show : =>
    @bBack = @tree.button_back.class
    @bNext = @tree.button_next.class
    @form = @tree.content?.form?.class
    @progress = @tree.progress_bar.progress
    @bNext.on 'submit', @next
    console.log @progress
    @bBack.on 'submit', => @bBack.submit()
  next : =>
    @form?.save?().then (success)=>
      if success
        try
          action = (@bNext?.dom?.find?('a')?.attr?('href') ? "").match?(/([^\/]*)$/)?[1] ? ''
          if action
            Feel.sendActionOnce 'registration_popup_'+action
        @bNext.submit()
    .done()




class @main
  show : =>
    @bBack = @tree.button_back.class
    @bNext = @tree.button_next.class
    @form = @tree.content?.form?.class
    #if @tree.content?.form?.subjects_detail?
      #@form = @tree.content.form.subjects_detail.class
    @progress = @tree.progress_bar.progress
    @bNext.on 'submit', @next
    console.log @progress
    #@bBack.submit()
  next : =>
    @form?.save?().then (success)=>
      @bNext.submit() if success
    .done()



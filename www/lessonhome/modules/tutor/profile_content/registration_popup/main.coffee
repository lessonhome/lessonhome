
class @main
  show : =>
    @bBack = @tree.button_back.class
    @bNext = @tree.button_next.class
    @form = @tree.content?.form?.class
    @progress = @tree.progress_bar.progress
    @bNext.on 'submit', @next
    @bBack.on 'submit', => @bBack.submit()
  next : => Q.spawn =>
    success = yield @form?.save?()
    return unless success
    try action = (@bNext?.dom?.find?('a')?.attr?('href') ? "").match?(/([^\/]*)$/)?[1] ? ''
    if action then Feel.sendActionOnce 'registration_popup_'+action
    @bNext.submit()



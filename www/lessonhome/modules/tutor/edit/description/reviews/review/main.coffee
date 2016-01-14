class @main
  constructor : ->
    $W @
  show : =>
    @found.remove_button.on 'click',=> @emit 'remove'
    @tree.review.class.dom.find('textarea').on 'input',=>
      @found.rtitle.text "Отзыв (#{@tree.review.class.getValue().length ? 0})"
    @found.rtitle.text "Отзыв (#{@tree.review?.length ? 0})"
  getValue : =>
    subject : @tree.subject .class.getValue()
    course  : @tree.course  .class.getValue()
    review  : @tree.review  .class.getValue()
    name    : @tree.name    .class.getValue()
    date    : @tree.date    .class.getValue()
    mark    : @tree.mark    .class.getValue()
    comment : @tree.comment .class.getValue()
    onmain  : @found.onmain.is(':checked')
  setValue : (data={})=>
    @tree.subject .class.setValue data.subject  ? []
    @tree.course  .class.setValue data.course   ? []
    @tree.review  .class.setValue data.review   ? ''
    @tree.name    .class.setValue data.name     ? ''
    @tree.date    .class.setValue data.date     ? ''
    @tree.mark    .class.setValue data.mark     ? ''
    @tree.comment .class.setValue data.comment  ? ''
    @found.onmain.prop('checked',data.onmain ? false)
    @found.rtitle.text "Отзыв (#{data.review?.length ? 0})"

    

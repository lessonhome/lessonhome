class @main
  constructor : ->
    $W @
  show : =>
    @found.remove_button.on 'click',=> @emit 'remove'
  getValue : =>
    subject : @tree.subject .class.getValue()
    course  : @tree.course  .class.getValue()
    review  : @tree.review  .class.getValue()
    name    : @tree.name    .class.getValue()
    date    : @tree.date    .class.getValue()
    mark    : @tree.mark    .class.getValue()
    comment : @tree.comment .class.getValue()
  setValue : (data={})=>
    @tree.subject .class.setValue data.subject  ? []
    @tree.course  .class.setValue data.course   ? []
    @tree.review  .class.setValue data.review   ? ''
    @tree.name    .class.setValue data.name     ? ''
    @tree.mark    .class.setValue data.mark     ? ''
    @tree.comment .class.setValue data.comment  ? ''

    

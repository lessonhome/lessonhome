
class @main
  Dom : =>
    @subject_div = @found.subject
    @details_data = @found.details_data
    @subject = @tree.subject.class

  show : =>
    @subject_div.on 'click', => @subjectOnClick @subject, @details_data


  subjectOnClick : (subject, details)=>
    subject.changeIcon()
    details.toggle()
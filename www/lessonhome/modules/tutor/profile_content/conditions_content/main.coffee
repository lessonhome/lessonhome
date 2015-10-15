
class @main
  Dom : =>
    @subject_div  = @found.subject
    @details_data = @found.details_data
    @subject = @tree.subject.class
    @map     = @tree.map.class
    @address = @tree.address

  show : => do Q.async =>
    @subject_div.on 'click', => @subjectOnClick @subject, @details_data
    ret = yield @map.go(@address)
  
  subjectOnClick : (subject, details)=>
    subject.changeIcon()
    details.toggle()

  setValue: (data)=>



class @main
  Dom : =>
    @subject_div  = @found.subject
    @details_data = @found.details_data
    @subject = @tree.subject.class
    @map     = @tree.map.class
    @address = @tree.address

  show : =>
    @subject_div.on 'click', => @subjectOnClick @subject, @details_data
    @map.go(@address).then (ret)->
      if !ret
        console.log ret


  subjectOnClick : (subject, details)=>
    subject.changeIcon()
    details.toggle()

  setValue: (data)=>


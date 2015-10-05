
class @main
  Dom : =>
    @changes_field = @found.changes_field
    @educations = []
  show : =>

    @educations.push @tree.tutor_edit.class

    for key, value of @tree.education
      unless key == '0'
        @addEducation(value)

    @save_button = @tree.save_button?.class
    @add_button = @tree.add_button?.class

    @save_button?.on 'submit', @b_save
    @add_button?.on 'submit', @addEducation

  b_save : =>

    i = 0

    console.log @educations

    for edu in @educations
      console.log 'edu', i, edu.getData()
      if i == @educations.length
        edu?.save?(i).then (success)=>
          if success
            console.log 'All sent'
            $('body,html').animate({scrollTop:0}, 500)
            @changes_field.fadeIn(1000)
            return true
        .done()
      else
        edu?.save?(i).then (success)=>
          if success
            return true
        .done()
      i++

  addEducation : (data)=>
    cloned = @tree.tutor_edit.class.$clone()

    if data?
      for key, value of data
        cloned[key].setValue(value)
    else
      cloned.country.setValue()
      cloned.city.setValue()
      cloned.university.setValue()
      cloned.faculty.setValue()
      cloned.chair.setValue()
      cloned.qualification.setValue()
      cloned.learn_from.setValue()
      cloned.learn_till.setValue()
    cloned.dom.appendTo('div.tutor_edit')
    @educations.push cloned


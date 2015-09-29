
class @main
  Dom: =>
    @header  = @found.header
    @content = @found.content
    @icon_wrap    = @found.icon_wrap
    @subject = @found.subject
    @comment = @found.comment
    @training_direction = @found.training_direction
    @category_of_student_val = @found.category_of_student_val
    @category_of_student_to_rus = {"school:0":"дошкольники","school:1":"младшая школа", "school:2":"средняя школа", "school:3":"старшая школа", "student":"студент", "adult":"взрослый" }
    @place_val = @found.place_val
    @place_to_rus = {"other":"другое", "pupil":"у ученика", "remote":"удалённо", "tutor":"у себя"}
    #####
    @places = {
      tutor : @found.place_tutor
      pupil : @found.place_pupil
      remote : @found.place_remote
    }

    #####
  show: =>
    $(@header).on 'click', =>
      @content.toggle()
      @icon_wrap.toggleClass('active')

  setValue: (key, val, place)=>
    @subject.text("#{key ? ""} :")
    course = val.course
    if course?
      for k, v of course
        if k > 0
          $(@training_direction).append(", #{v}")
        else
          $(@training_direction).append(v)
    @comment.text("#{val.description ? ""}")
    if val.place_prices?
      for place, prices of val.place_prices
        if (place_block = @places[place])?
          place_block.show()
          fields = {
            v60 : place_block.find '.price.v60:first'
            v90 : place_block.find '.price.v90:first'
            v120 : place_block.find '.price.v120:first'
          }
          for time, cost of prices
            if (time_block = fields[time])?
              time_block.show()
              time_block.find('.cost:first').text cost + ' руб.'

    else
      p1 = val.price.left
      p2 = val.price.right
      t1 = val.duration.left
      t2 = val.duration.right
      delta_t = t2 - t1
      if delta_t == 0
        @found.v.text(t2+" минут : "+p1+" - "+p2+" руб.")
        return 0
      k = (p2 - p1)/delta_t
      if (k > 200 || k < 4) then k = 14
      v60  = k*(60 - t1)  + p1
      v90  = k*(90 - t1)  + p1
      v120 = k*(120 - t1) + p1
      v60 = @getPriceValue v60
      v90 = @getPriceValue v90
      v120 = @getPriceValue v120
      @found.v60.show()
      @found.v90.show()
      @found.v120.show()
      if v60 > 400
        @found.v60_val.text(v60+" руб.")
      else
        @found.v60.hide()
      @found.v90_val.text(v90+" руб.")
      @found.v120_val.text(v120+" руб.")
    i = 0
    for k, v of val.tags
      if v == true
        if @category_of_student_to_rus[k]
          if i > 0
            $(@category_of_student_val).append(", "+@category_of_student_to_rus[k])
            @found.category_of_student.show()
          else
            $(@category_of_student_val).append(@category_of_student_to_rus[k])
            @found.category_of_student.show()
          i++
    i = 0
    for k, v of place
      if v == true
        console.log k, v
        if @place_to_rus[k]
          if i > 0
            $(@place_val).append(", "+@place_to_rus[k])
            @found.place.show()
          else
            $(@place_val).append(@place_to_rus[k])
            @found.place.show()
          i++
  getPriceValue: (val)=>
    val /= 50
    val = Math.round(val)
    val *= 50
    return val


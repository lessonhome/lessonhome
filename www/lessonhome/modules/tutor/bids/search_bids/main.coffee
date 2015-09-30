class @main extends EE
  Dom : =>
    @filter = {}
    @extra = @found.extra
    @extra_filters_button_wrap = @found.extra_filters_button_wrap
    # buttons
    @show_extra_filters = @found.show_extra_filters
    @cancel_button = @found.cancel_button
    @apply_filters_button = @found.apply_filters_button
  show : =>
    $(@show_extra_filters).on 'click', =>
      @extra.show()
      @extra_filters_button_wrap.addClass 'show'
      @show_extra_filters.hide()

    $(@cancel_button).on 'click', =>
      @extra.hide()
      @extra_filters_button_wrap.removeClass 'show'
      @show_extra_filters.show()

    $(@apply_filters_button).on 'click', =>
      @extra.hide()
      @extra_filters_button_wrap.removeClass 'show'
      @show_extra_filters.show()


    console.log @tree

    @tree.subject.class.on 'change', => @emit 'change', {subject: @tree.subject.class.getValue()}

    @tree.course.class.on 'change', => @emit 'change', {course: @tree.course.class.getValue()}

    @tree.calendar.class.on 'change', => @emit 'change', {date: @tree.calendar.class.getValue()}

    #================= categories

    @tree.pre_school.class.on 'change', => @emit 'change', {pre_school: @tree.pre_school.class.getValue()}
    @tree.junior_school.class.on 'change', => @emit 'change', {junior_school: @tree.junior_school.class.getValue()}
    @tree.medium_school.class.on 'change', => @emit 'change', {medium_school: @tree.medium_school.class.getValue()}
    @tree.high_school.class.on 'change', => @emit 'change', {high_school: @tree.high_school.class.getValue()}
    @tree.student_categories.class.on 'change', => @emit 'change', {student: @tree.student_categories.class.getValue()}
    @tree.adult.class.on 'change', => @emit 'change', {adult: @tree.adult.class.getValue()}

    @tree.price.class.on 'change', => @emit 'change', {price: @tree.price.class.getValue()}

    #================ place

    @tree.place_tutor.class.on 'change', => @emit 'change', {place_tutor: @tree.place_tutor.class.getValue()}
    @tree.place_pupil.class.on 'change', => @emit 'change', {place_pupil: @tree.place_pupil.class.getValue()}
    @tree.place_remote.class.on 'change', => @emit 'change', {place_remote: @tree.place_remote.class.getValue()}
    @tree.place_cafe.class.on 'change', => @emit 'change', {place_cafe: @tree.place_cafe.class.getValue()}

    @tree.area.class.on 'change', => @emit 'change', {area: @tree.area.class.getValue()}

    #================ road time

    @tree.road_time_15.class.on 'change', => @emit 'change', {road_time_15: @tree.road_time_15.class.getValue()}
    @tree.road_time_30.class.on 'change', => @emit 'change', {road_time_30: @tree.road_time_30.class.getValue()}
    @tree.road_time_45.class.on 'change', => @emit 'change', {road_time_45: @tree.road_time_45.class.getValue()}
    @tree.road_time_60.class.on 'change', => @emit 'change', {road_time_60: @tree.road_time_60.class.getValue()}
    @tree.road_time_90.class.on 'change', => @emit 'change', {road_time_90: @tree.road_time_90.class.getValue()}
    @tree.road_time_120.class.on 'change', => @emit 'change', {road_time_120: @tree.road_time_120.class.getValue()}


    @tree.choose_gender.class.on 'change', => @emit 'change', {gender: @tree.choose_gender.class.getValue()}



    @on 'change', (data)=>
      for key, val of data
        @updateFilter key, val

  updateFilter: (prop, data) =>
    console.log 'upd', @filter, prop, data

    switch true
      when /subject/.test prop
        @filter[prop] = [data]
      when /road_time/.test prop
        if data
          if !@filter.time_spend_way? || +(prop.replace 'road_time_', '') > +@filter.time_spend_way
            @filter.time_spend_way = prop.replace 'road_time_', ''

            console.log @tree[prop].class.getValue()
            #console.log @tree.road_time_30.class.getValue()
            #console.log @tree.road_time_45.class.getValue()
            #console.log @tree.road_time_60.class.getValue()
            #console.log @tree.road_time_90.class.getValue()
            #console.log @tree.road_time_120.class.getValue()



      else
        @filter[prop] = data

    console.log 'updated', @filter
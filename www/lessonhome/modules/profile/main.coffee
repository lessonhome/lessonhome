class @main
  constructor : ->
    $W @
  Dom : =>
    @status_values =
      student:"Студент"
      private_teacher:"Частный преподаватель"
      university_teacher:"Преподаватель ВУЗа"
      school_teacher:"Преподаватель школы"

    @chooseTutor  = @found.tutor_trigger
    @triggerCount = 0

    #scroll spy
    @reviewMark   = @found.review_mark
    @profileTab   = @found.profile_tab

  show: =>

    class @template
      constructor : (name, keys = []) ->
        @name = name
        @keys = keys
        @parent = $(".#{@name}:first")

        @clone = @parent.find(".#{'template_' + @name}:first").clone()
        @clone = $(".#{'template_' + @name}:first").clone() unless @clone.length
        classes = ''
        classes += "#{if i > 0 then ',' else ''}.#{key}:first" for key, i in @keys
        fields = @clone.find classes
        @fields = {}
        @fields[key] = fields.filter(".#{key}") for key in @keys
      set : (name, value = "") ->
        @fields[name].text(value) if @fields[name]? and @fields[name].length
      past : ->
        @parent.append @clone.clone().children()
        @set(key) for key in @keys

    #scroll spy
    @reviewMark.scrollSpy()
    #tabs
    @profileTab.tabs()
    
    #@found.profile_tabs.tabs()
    @chooseTutor.on 'click', => Q.spawn => yield @onTutorChoose()
    Feel.urlData.on 'change',=> Q.spawn => yield @setLinked()
    @found.back.click (e)=>
      return unless e.button == 0
      e.preventDefault()
      Q.spawn => yield @goBack()
    yield @open()

  open : (index)=>
    state = History.getState()
    if (((""+document.referrer).indexOf(document.location.href.substr(0,15)))!=0)&&(window.history.length<2)
      @found.back.addClass 'hidden'
    else
      @found.back.removeClass 'hidden'

    unless index?
      @index = yield Feel.urlData.get('tutorProfile','index') ? 77
    else @index = index

    preps = yield Feel.dataM.getTutor [@index]
    prep = preps[@index]
    return unless prep?
    console.log prep
    @setValue prep
    yield @setLinked()
  goBack : =>
    if @tree.single_profile!='tutor_profile'
      return yield Feel.main.hideTutor()
    if (window.history.length>1) && History.back()
      setInterval (=> Q.spawn => yield @goHistoryUrl()),2000
      return yield @goHistoryUrl()
    document.location.href = document.referrer
  goHistoryUrl : => setTimeout (-> document.location.href = History.getState().url),100


   

  onTutorChoose : =>
    active  = !@found.tutor_trigger.hasClass('selected')
    @tutorChoose      active
    yield @setLinked  active,false
  setLinked : (active,choose = true)=>
    return unless @index
    linked = yield Feel.urlData.get 'mainFilter','linked','reload'
    state = active ? linked?[@index]==true
    if active?
      unless state
        delete linked?[@index]
      else
        linked?[@index] = true
      yield Feel.urlData.set 'mainFilter','linked',linked
    @tutorChoose state==true if choose
  tutorChoose : (active)=>
    console.log 'tutorchoose',active
    if active
      @found.tutor_trigger.addClass('waves-light teal lighten-2 selected white-text').removeClass('btn-trigger waves-teal')
      @found.tutor_trigger.find('.tutor_button_text').html('Убрать')
      @found.tutor_trigger.find('.material-icons').html('remove')
    else
      @found.tutor_trigger.removeClass('waves-light teal lighten-2 selected white-text').addClass('btn-trigger waves-teal')
      @found.tutor_trigger.find('.tutor_button_text').html('Выбрать')
      @found.tutor_trigger.find('.material-icons').html('add')
  setPhotos : (photos)=>
    @found.view_photo.attr 'src',photos[Object.keys(photos).length-1].hurl
    @found.view_photo.attr 'data-caption',@name
    console.log 'materialbox'
    @found.view_photo.materialbox()
    @found.view_photo.addClass 'materialboxed'

  setRating : (rating)=>

  setNewFormatPrice : (data) ->
    places = []
    subject = data.subjects[ Object.keys(data.subjects)[0] ]

    for k in ['tutor', 'pupil', 'remote']
      return if subject.place_prices[k]?
      places.push(k) if data.place?[k]

    return unless places.length

    roundFifty = (val) ->
      val /= 50
      val = Math.round(val)
      val *= 50
      return val

    p1 = subject.price.left
    p2 = subject.price.right
    t1 = subject.duration.left
    t2 = subject.duration.right
    delta_t = t2 - t1

    if delta_t != 0 then k = (p2 - p1)/delta_t else k = 14
    if (k > 200 || k < 4) then k = 14

    new_price =
      v60 : roundFifty( k*(60 - t1)  + p1 )
      v90 : roundFifty( k*(90 - t1)  + p1 )
      v120 : roundFifty( k*(120 - t1) + p1 )

    subject.place_prices[k] = new_price for k in places

  setValue : (data={})=>

    @setNewFormatPrice data

    @tree.value ?= {}
    @tree.value[key] = val for key,val of data
    data = @tree.value
    @name = "#{data.name.first || ""} #{data.name.middle || ''}"

    yield @setPhotos data.photos
    yield @setRating data.rating
    @found.full_name.text("#{@name}")
    if data.age? && data.age
      age_end = data.age%10
      switch age_end
        when 1
          @found.age_value.text(", "+data.age+" год")
        when 2
          @found.age_value.text(", "+data.age+" года")
        when 3
          @found.age_value.text(", "+data.age+" года")
        when 4
          @found.age_value.text(", "+data.age+" года")
        else
          @found.age_value.text(", "+data.age+" лет")
    else
      @found.age_value.text("")

    l = data?.location ? {}

    trim = (val) ->
      val = val.replace /^\s+/,''
      val = val.replace /\s+$/,''

    cA = (str="",val,rep=', ')->
      return str unless val
      val = ""+val
      trim val
      return str unless val
      unless str
        str += val
      else
        str += rep+val

    ls1 = ""
    ls1 = cA ls1,l.city
    ls1 = cA ls1,l.area
#    if Feel.user?.type?.admin
#      ls1 = cA ls1,data.login,'<br>'
#      ls1 = cA ls1,data.phone?.join('; '),'<br>'
#      ls1 = cA ls1,data.email?.join('; '),'<br>'
    ls3 = ""
    if l.metro
      stations = l.metro.split(',').map (station) -> "м. #{trim station}"
      ls3 += stations.join(', ')
    ls = ""
    ls = cA ls,ls1
    ls = cA ls,ls3

    @found.location.text ls

    ###
    if data.location?.country
      if data.location?.city
        if data.location?.area
          @found.location.text("#{data.location?.country ? ""}, г.#{data.location?.city ? ""} р.#{data.location?.area ? ""}")
        else
          @found.location.text("#{data.location?.country ? ""}, г.#{data.location?.city ? ""}")
      else
        @found.location.text(data.location?.country ? "")
    else
      @found.location.hide()
    ###
    @setLinked()

    if data.slogan? && data.slogan
      @found.slogan.text data.slogan
      @found.slogan.show()

    if data.place? && data.place
      @found[place]?.show()? for place of data.place

    if data.status? && data.status then @found.status.text @status_values[data.status]
    if data.experience? && data.experience then @found.experience.text data.experience

    if data.subjects?
      for name in data.ordered_subj
        clone = @tree.price_subject.class.$clone()
        clone.setTitle name
        clone.setValue(data.subjects[name].place_prices)
        @found.prices.append($('<div class="row">').append(clone.dom))
#      keys = Object.keys data.subjects
#      first_subject = data.subjects[ keys[0] ]
#      @tree.price_subject.setValue


#    if data.education? && data.education.length
#      educations = new @template 'education', ['title', 'city', 'period', 'info']
#      for val in data.education
#        educations.set 'title', val.name
#        educations.set 'city', "г. #{val.city}"
#        educations.set 'period', "#{val.period.start} - #{val.period.end} гг."
#        educations.set 'info', "#{val.faculty}#{if val.qualification then ', ' + val.qualification else ''}"
#        educations.past()


#    if data.subjects?
#      for name, val of data.subjects
#        console.log @tree.price_subject.class.$clone().dom
#      subjects = new @template 'subjects', ['name', 'training_direction', 'description', 'prices', 'plus-price']
#      for name, val of data.subjects
#        subjects.set 'name', name
#        subjects.set('training_direction', val.course.join(', ') ) if val.course? and val.course.length
#        subjects.set 'description', val.description
#        subjects.past()

#    last_work = data.work?[Object.keys(data.work ? {})?.pop?()]
#    if last_work
#      if last_work.place? && last_work.place
#        #alert last_work.post?
#        #alert last_work.post
#        if last_work.post? && last_work.post
#          @found.work_place_value.text(last_work.place, last_work.post)
#        else
#          @found.work_place_value.text(last_work.place)
#      else
#        @found.work_place.hide()
#    else
#      @found.work_place.hide()

#    if data.education?[0]?.name
#      if data.education?[0]?.faculty
#        @found.education_value.text("#{data.education?[0]?.name ? ""}, #{data.education?[0]?.faculty ? ""}")
#      else
#        @found.education_value.text("#{data.education?[0]?.name ? ""}")
#    else
#      @found.education.hide()

    if data.check_out_the_areas?
      for key, val of data.check_out_the_areas
        if key > 0
          $(@areas_departure_value).append(", #{val}")
        else
          $(@areas_departure_value).append(val)
    else
      @areas_departure.hide()
    @found.about_text.text("#{data.about ? ""}")
    if data.interests?
      for key, val of data.interests
        if val.description
          if key > 0
            $(@found.interests_val).append(", #{val.description}")
            @found.interests.show()
          else
            $(@found.interests_val).append(val.description)
            @found.interests.show()
    if data.reason? && data.reason
      @found.reason_val.text(data.reason)
      @found.reason.show()
    #@honors_text.text("#{data.honors_text ? ""}")
    subjects_number = 0
    @tutor_subjects = []
    @subjects_content.empty()
    console.log data.subjects
    for key,val of data.subjects
      ss = key.split /[\.,;]/
      for s in ss
        s = s.replace /^\s+/,''
        s = s.replace /\s+$/,''
        if s.length > 2
          @tutor_subjects.push [s,val]
          subjects_number++
    newarr = []
    for s in @tutor_subjects
      new_subject = @hidden_subject.$clone()
      new_subject.setValue s[0], s[1], data.place
      newarr.push s[0]
      @subjects_content.append(new_subject.dom)
    @tutor_subjects = newarr
    console.log @tutor_subjects
    # right panel
    $(@found.write_tutor_msg).on 'click', =>
      @found.write_tutor_name.addClass 'shown'
      @found.write_tutor_phone.addClass 'shown'
      @found.write_tutor_subject.addClass 'shown'
    $(@write_button).on 'click', =>
      @found.write_tutor_name.addClass 'shown'
      @found.write_tutor_phone.addClass 'shown'
      @found.write_tutor_subject.addClass 'shown'
    dative_tutor_name = @dativeName data.name
    @found.write_tutor_title.text("Написать "+dative_tutor_name.first)
    @tree.write_button.class.setValue "Написать "+dative_tutor_name.first
    if subjects_number > 1
      @tree.subject.class.setItems @tutor_subjects
    else
      @tree.subject.class.setValue @tutor_subjects[0]
      @found.write_tutor_subject.hide()
    @dom.css 'opacity',1


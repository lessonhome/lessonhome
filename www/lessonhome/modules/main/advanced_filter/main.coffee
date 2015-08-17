class @main extends EE
  Dom : =>
    @inputs =
      tutor_status : 'student,school_teacher,university_teacher,private_teacher,native_speaker'
      place : 'pupil,tutor,remote,area'
      subject : 'subject'
      course  : 'course'
      price : 'price'
      group_lessons : 'group_lessons'
      experience : 'little_experience,big_experience,bigger_experience'
      time_to_way : 'time_spend_way'
      verification : 'with_reviews,with_verification'
      sex : 'choose_gender'
    for block,arr of @inputs
      @inputs[block] = {}
      b = @inputs[block]
      b.reset   = @found[block+'_reset']
      b.inputs  = arr.split ','
  show : =># do Q.async =>
    for block,b of @inputs
      arr = b.inputs
      b.inputs  = {}
      do (b)=>
        b.reset?.click? =>
          vals = {}
          for n,i of b.inputs
            i?.class?.setValue?()
            vals[n] = i?.class?.getValue()
          b.hash_default = objectHash.sha1 vals
          b.reset.hide()
        b.get = =>
          ret = {}
          for n,i of b.inputs
            ret[n] = i?.class?.getValue?()
          return ret
        b.set = (v)=>
          vals = {}
          for n,i of b.inputs
            i?.class?.setValue? v?[n]
            vals[n] = i?.class?.getValue()
          hash = objectHash.sha1 vals
          unless b.hash_default? && b.hash_default==hash
            b.reset?.show?()
      for input in arr
        b.inputs[input] = i = {}
        i.class = @tree?[input]?.class
        do (b)=> i?.class?.on? 'change', =>
          vals = {}
          for n_,i_ of b.inputs
            vals[n_] = i_?.class?.getValue()
          hash = objectHash.sha1 vals
          unless b.hash_default? && b.hash_default==hash
            b.reset?.show?()
          @emit 'change'
      vals = {}
      for n,i of b.inputs
        vals[n] = i?.class?.getValue()
      b.hash_default = objectHash.sha1 vals

    #@on 'change', => #Q.spawn =>
    #  v = @getValue()
    #  console.log v


    # change visibility show_hidden
    @sections = @found.section
    for section in @sections
      section = $ section
      do (section)=>
        title = section.find(">.title")
        title.click => @change_visibility section


  change_background : (element)=>
    if element.is '.background'
      element.removeClass('background').addClass 'hover'
      @emit 'change'
      @emit 'end'
    else
      element.addClass('background').removeClass 'hover'
      @emit 'change'
      @emit 'end'
  change_visibility : (element)=>
    if element.is '.showed'
      element.removeClass 'showed'
    else
      element.addClass 'showed'


  getValue : => @getData()

  setValue : (data)=>
    b?.set? data?[block] for block,b of @inputs

  getData : =>
    ret = {}
    ret[block] = b?.get?() for block,b of @inputs
    return ret

  resetAllFilters : => true
    # TODO: write a function

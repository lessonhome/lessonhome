class @main
  Dom : =>
    @sub = @tree.subjects.class
    @form = {
      price : @found.price
      index : @found.index
      executor : @found.index_tutor
      name : @found.name
      phone : @found.phone
      email : @found.email
      subjects : @sub
      moderate : @found.moderate
    }
  show: =>
    @sub.setValue @tree.value.subjects
    @dom.find("a.show").on 'click', @onShowDetail
    @found.make.on 'click', @onMakeExecutor
    @found.save.click @onSaveChange

  onShowDetail : (e) =>
    a = $(e.currentTarget)
    index = a.attr('data-index')
    tutor = @tree.value.link_detail[index]

    if tutor?
      @dom.find("a.show").css {opacity: ''}
      a.css {opacity: 0.8}
      @found.about_tutor.show().attr('data-index', index)
      @found.avatar.attr('src', tutor.photos[0].hurl)
      @found.name.text("#{tutor.name.first} #{tutor.name.middle} #{tutor.name.last}")
      Q.spawn =>
        link = '/tutor_profile?'+yield Feel.udata.d2u('tutorProfile',{index})
        @found.to_profile.attr('href', link)

    return false

  onMakeExecutor : (e) =>
    index = $(e.currentTarget).closest('.about_tutor').attr('data-index')
    @form.executor.val(index)
    @dom.find("a.show[data-index]").each ->

      if $(this).is "[data-index=\"#{index}\"]"
        $(this).addClass('selected')
      else
        $(this).removeClass('selected')

    return false

  onSaveChange : =>
    data = @getValue()
    console.log data
    console.log yield Feel.jobs.server 'changeBid', data

  getStatus : =>
    result = {}
    @found.status.find('input[type="checkbox"]').each ->
      result[this.value] = $(this).is ':checked'
      return true
    return result

  getGender : => @found.gender.find('input[type="radio"]:checked').val()

  getValue : =>
    price : @form.price.val()
    status : @getStatus()
    index : @form.index.val()
    gender : @getGender()
    id : @form.executor.val()
    name : @form.name.val()
    phone : @form.phone.val()
    email : @form.email.val()
    subjects : @form.subjects.getValue()
    moderate : @form.moderate.prop('checked')
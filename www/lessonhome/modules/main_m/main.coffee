

class @main
  constructor: ->
    $W @
  Dom : =>
    @appProgress      = @found.app_progress
    @appFormOne       = @found.app_first_form
    @appFormTwo       = @found.app_two_form
    @appFormThree     = @found.app_three_form
    @defaultAppStep   = 0
    @slickBlock       = @found.slick_block

    @slickBlock.slick({
      dots: false,
      infinite: true,
      slidesToShow: 4,
      slidesToScroll: 4,
      responsive: [
        {
          breakpoint: 1000,
          settings: {
            infinite: true,
            slidesToShow: 2,
            slidesToScroll: 2
          }
        },
        {
          breakpoint: 480,
          settings: {
            infinite: true,
            slidesToShow: 1,
            slidesToScroll: 1
          }
        }
      ]
    })

    @fast_form =
      subjects: new $._material_select @found.fast_sub
      metro: new $._material_select @found.fast_branch

    @metroColor @fast_form.metro

    @appFormLabel     = @found.form_offset_label
    @fixedHeightBlock = @found.fixed_height
  show: =>

    getListener  = (name, element) -> ->
      Q.spawn ->
        yield Feel.sendActionOnce('interacting_with_form', 1000*60*10)
        yield Feel.urlData.set 'pupil', name, element.val()

    @fast_form.subjects.on 'change', getListener('subjects', @fast_form.subjects)

    @found.attach.on    'click', => Q.spawn => Feel.jobs.solve 'openBidPopup', null, 'motivation'
    @found.send_form.on 'click', => Q.spawn => @sendFastForm()


    @prepareLink @found.rew.find('a')

    Q.spawn =>
      indexes = []
      for own key, t of @tree.main_rep then indexes.push t.index
      yield Feel.dataM.getTutor indexes

  sendFastForm: =>
    subjects = @fast_form.subjects.val()
    metro = @fast_form.metro.val()
    @found.fast_filter.attr('action', "/tutors_search?#{ yield Feel.udata.d2u 'tutorsFilter', {subjects, metro}}")
    @found.fast_filter.submit()

  metroColor : (_material_select) =>
    return unless @tree.metro_lines?
    _material_select.ul.find('li.optgroup').each (i, e) =>
      li = $(e)
      name = li.next().attr('data-value')
      return true unless name
      name = name.split(':')
      return true if name.length < 2
      return true unless @tree.metro_lines[name[0]]?
      elem = $('<i class="material-icons middle-icon">fiber_manual_record</i>')
      elem.css {color: @tree.metro_lines[name[0]].color}
      li.find('span').prepend(elem)


  getValue:  =>

  setValue : (data) ->
    @fast_form.subjects.val(data.subjects)

  prepareLink : (a)=>
    a.filter('a').off('click').on 'click', (e)->
      link = $(this)
      index = link.attr('data-i')
      e.preventDefault()
      if index?
        Feel.main.showTutor index, link.attr 'href'
      return false

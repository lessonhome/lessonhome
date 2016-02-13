class @main
  show: =>
    @dom.find("a.show").on 'click', (e) =>
      a = $(e.currentTarget)
      index = a.attr('data-index')
      tutor = @tree.value.link_detail[index]

      if tutor?
        @dom.find("a.show").css {opacity: ''}
        a.css {opacity: 0.5}
        @found.about_tutor.show().attr('data-index', index)
        @found.avatar.attr('src', tutor.photos[0].hurl)
        @found.name.text("#{tutor.name.first} #{tutor.name.middle} #{tutor.name.last}")
        Q.spawn =>
          link = '/tutor_profile?'+yield Feel.udata.d2u('tutorProfile',{index})
          @found.to_profile.attr('href', link)

      return false
    @found.make.on 'click', (e) =>
      index = $(e.currentTarget).closest('.about_tutor').attr('data-index')

      if index
        Q.spawn =>
          {status, err} = yield Feel.jobs.server 'setDoiter', @tree.value._id, index
          console.log status, err

          if status == "success"
            @dom.find("a.show[data-index]").removeClass('selected')
            @dom.find("a.show[data-index=\"#{index}\"]").addClass('selected')

      return false
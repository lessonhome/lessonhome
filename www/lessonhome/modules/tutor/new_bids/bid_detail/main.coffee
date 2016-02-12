class @main
  show: =>
    @dom.find('a.make_super').on 'click', (e) =>
      a = $(e.currentTarget)
      account = a.attr('data-id')
      Q.spawn =>
        {status, err} = yield Feel.jobs.server 'setDoiter', @tree.value._id, account
        console.log err
        if status == 'success'
          a.css {opacity: 0.1}

      return false


class @main
  show : =>
    @prepareLink @dom.find('a')
    @found.attach_pos.on    'click', => Q.spawn => Feel.jobs.solve 'openBidPopup', 'null', 'motivation'
  prepareLink : (a)=>
    index = @tree.value?.index

    if index
      a.filter('a').off('click.prep').on 'click.prep', (e)=>
        return unless Feel.main.inited
        return unless e.button == 0
        e.preventDefault()
        href = $(e.currentTarget).attr 'href'
        Q.spawn => Feel.main.showTutor index, href
        return false





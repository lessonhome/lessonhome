class @main extends @template '../../tutor'
  route : '/tutor/bid_detail'
#  model   : 'tutor/new_bids/bid_detail'
  title : "поиск заявок"
  tags   : -> 'tutor:search_bids'
  access : ['tutor']
  redirect : {
    'other': '/enter'
    'pupil': '/enter'
  }
  tree : =>
    items : [
      @module 'tutor/header/button' : {
        title : 'Поиск'
        href  : '/tutor/search_bids'
        tag   : 'tutor:search_bids'
      }
      @module 'tutor/header/button' : {
        title : 'Отчёты'
        href  : '/tutor/reports'
      }
      @module 'tutor/header/button' : {
        title : 'Входящие'
        href  : '/tutor/in_bids'
      }
      @module 'tutor/header/button' : {
        title : 'Исходящие'
        href  : '/tutor/out_bids'
      }
    ]
    content : @module '$' :
      value : $defer : =>
        _id = _setKey @req.udata,'tutorBids.index'
        bid = {}

        if _id
          jobs = yield Main.service 'jobs'
          bid = yield jobs.solve 'getDetailBid', @req.user,  _id
          bid.link_detail = linked = {}

          if (id = bid.id)?
            linked[id] = yield jobs.solve 'getTutor', {index:id}

          if bid.linked?
            for own key of bid.linked when !linked[key]?
              linked[key] = yield jobs.solve 'getTutor', {index:key}

        return bid

  init : ->
    @parent.tree.left_menu.setActive 'Заявки'

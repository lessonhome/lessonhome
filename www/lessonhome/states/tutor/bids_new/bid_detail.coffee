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
    filter = @const('filter')
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
      obj_status : filter.obj_status
      gender : filter.sex
      price : filter.price
      subjects : @state '../forms/drop_down_list_with_tags' :
        list: @module 'tutor/forms/drop_down_list:type1'  :
          smart : true
          self : true
          selector        : 'advanced_filter_form'
          placeholder     : 'Введите предмет'
          value     : ''
        tags: ''

      value : $defer : =>
        _id = _setKey @req.udata,'tutorBids.index'
        bid = {}

        if _id
          jobs = yield Main.service 'jobs'
          bid = yield jobs.solve 'getDetailBid', @req.user,  _id
          bid.link_detail = linked = {}

          if (id = bid.id)? and id
            linked[id] = yield jobs.solve 'getTutor', {index:id}

          if bid.linked?
            for own id of bid.linked when !linked[id]?
              linked[id] = yield jobs.solve 'getTutor', {index:id}

        return bid

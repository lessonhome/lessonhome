class @main extends @template '../../tutor'
  forms : ['bids_moderate']
  route : '/tutor/moderate_bids'
#  model   : 'tutor/new_bids/moderate_bids'
  title : "поиск заявок"
  tags   : -> 'tutor:search_bids'
  access : ['admin']
  redirect : {
    'tutor' : '/enter'
    'other' : '/enter'
    'pupil' : '/enter'
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
      value : $form : bids_moderate : 'bids'


  init : ->
    @parent.tree.left_menu.setActive 'Модерация заявок'

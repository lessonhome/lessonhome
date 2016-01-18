class @main extends @template '../tutor'
  route : '/tutor/withdraw'
  model   : 'tutor/pay'
  title : "списание со счета"
  access : ['admin']
  redirect : {
    'tutor' : '/enter'
    'other' : '/enter'
    'pupil' : '/enter'
  }
  forms : [{bills: ['transactions', 'current_sum']}]
  tree : =>
    items : [
      @module 'tutor/header/button' : {
        title : 'Поиск'
        href  : '/tutor/search_bids'
      }
      @module 'tutor/header/button' : {
        title : 'Отчёты'
        href  : '/tutor/reports'
      }
      @module 'tutor/header/button' : {
        title : 'Входящие'
        href  : '/tutor/in_bids'
        tag   : 'tutor:in_bids'
      }
      @module 'tutor/header/button' : {
        title : 'Исходящие'
        href  : '/tutor/out_bids'
      }
    ]
    content       : @module '$' :

      current_sum : $form: bills : 'current_sum'
      transactions : $form: bills : 'transactions'
      date : @module 'tutor/forms/input' :
        placeholder : 'Дата транзации'
        selector: 'write_tutor'
        allowSymbolsPattern : "^\\d*$"

      send_input : @module 'tutor/forms/input' :
        placeholder : 'Cумма'
        selector: 'write_tutor'
        allowSymbolsPattern : "^\\d*$"

      add_btn : @module 'link_button' :
        text : 'Добавить'
        selector: 'view'

      save_btn : @module 'link_button' :
        text : 'Сохранить изменения'
        selector: 'edit_save'

      description : @module 'tutor/forms/textarea':
        placeholder: 'Дополнение к описанию (не обязательно)'
  init : ->
    @parent.tree.left_menu.setActive 'Управление счетом'

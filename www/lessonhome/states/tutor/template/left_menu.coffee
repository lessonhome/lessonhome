@struct = module 'tutor/template/menu/left_menu' :
  items : [
    module '//item' :
      title : 'Анкета'
      item_class : 'profile'
      href : 'profile'

    module '//item' :
      title : 'Заявки'
      item_class : 'bids'
      href : 'bids'

    module '//item' :
      title : 'Оплата'
      item_class : 'payment'
      href : '#'

    module '//item' :
      title : 'Документы'
      item_class : 'documents'
      href : '#'

    module '//item' :
      title : 'Форум'
      item_class : 'forum'
      href : '#'

    module '//item' :
      title : 'Статьи'
      item_class : 'articles'
      href : '#'

    module '//item' :
      title : 'Поддержка'
      item_class : 'support'
      href : '#'

  ]
  active_item : 'Анкета'
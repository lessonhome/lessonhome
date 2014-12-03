class @main
  tree : -> module 'tutor/template/menu/left_menu' :
    items : [
      module '//item' :
        title : 'Анкета'
        item_class : 'profile'
        href : 'profile'

      module '//item' :
        title : 'Заявки'
        item_class : 'bids'
        href : 'search_bids'

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
    setActive : (title)=>
      for item in @tree.items
        item.active = (item.title==title)


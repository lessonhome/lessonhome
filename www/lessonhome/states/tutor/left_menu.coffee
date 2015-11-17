class @main
  tree : -> @module '$' :
    items : [
      @module '//item' :
        title : 'Анкета'
        item_class : 'profile'
        href : '/tutor/profile'

      @module '//item' :
        title : 'Заявки'
        item_class : 'bids'
        href : '/tutor/search_bids'

      @module '//item' :
        title : 'Оплата'
        item_class : 'payment'
        href : '/tutor/pay'
      ###
      @module '//item' :
        title : 'Документы'
        item_class : 'documents'
        href : '#'

      @module '//item' :
        title : 'Форум'
        item_class : 'forum'
        href : '#'

      @module '//item' :
        title : 'Статьи'
        item_class : 'articles'
        href : '#'
      ###
      @module '//item' :
        title : 'Поддержка'
        item_class : 'support'
        href : '/tutor/support'

    ]
    setActive : (title)=>
      for item in @tree.items
        item?.active = (item?.title==title)
    setLinks  : (links)=>
      for link,i in links
        @tree?.items?[i]?.href = link

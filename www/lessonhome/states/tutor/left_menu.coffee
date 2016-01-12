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
    admin : [
      @module '//item' :
        title : 'Управление счетом'
        item_class : 'profile'
        admin:1
        href : '/tutor/withdraw'
      @module '//item' :
        title : 'Отзывы/Удаление'
        item_class : 'profile'
        admin:1
        href : '/tutor/edit/reviews'
      @module '//item' :
        title : 'Отправить смс'
        item_class : 'profile'
        admin:1
        href : '/sms'
      @module '//item' :
        title : 'Админка'
        item_class : 'bids'
        admin:2
        href : '/admin/tutors'
      @module '//item' :
        title : 'Фильтрация'
        item_class : 'bids'
        admin:2
        href : '/second_step'
      @module '//item' :
        title : 'Статистика заявок'
        item_class : 'support'
        admin:3
        href : 'https://docs.google.com/spreadsheets/d/1J7HUX5JpXlezyc61qOZqp-YZAxGXc-FjCozZpAvHm-o/edit#gid=0'
      @module '//item' :
        title : 'История смс'
        item_class : 'support'
        admin:3
        href : 'https://st.iqsms.ru/reports/online/'
    ]
    setActive : (title)=>
      for item in @tree.items
        item?.active = (item?.title==title)
      for item in @tree.admin
        item?.active = (item?.title==title)
    setLinks  : (links)=>
      for link,i in links
        @tree?.items?[i]?.href = link

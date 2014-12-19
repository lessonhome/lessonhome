class @main
  tree : -> module 'tutor/template' :
    depend        : [
      module 'tutor/edit'
      state 'lib'
    ]
    header        : state './header'  :
      icons       : module 'tutor/template/header/icons'
      items : [
        module 'tutor/template/header/button' : {
          title : 'Поиск'
          href  : '/search'
        }
        module 'tutor/template/header/list_button' : {
          title : 'Стать учеником'
          href  : '/be-pupil'
          list  : {
            'Тест' : '#'
            'Тест1' : '#'
            'Тест2' : '#'
          }
        }
        module 'tutor/template/header/list_button' : {
          title : 'Репетиторам'
          href  : '/for-tutors'
          list  : {
            'как это работает1' : '#'
            'как это работает2' : '#'
            'как это работает3' : '#'
          }
        }
        module 'tutor/template/header/button' : {
          title : 'О нас'
          href  : '/about us'
        }
      ]
    left_menu     : state './left_menu'
    sub_top_menu  : @exports()   # define if exists
    content       : @exports()   # must be defined
    vars :
      input_width1 : '335px'
      input_width2 : '90px'
      input_width3 : '100px'
  setTopMenu : (active, items)=>
    @tree.header.top_menu.items        = items
    @tree.header.top_menu.active_item  = active

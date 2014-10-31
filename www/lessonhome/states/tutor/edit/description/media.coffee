@route = '/tutor/edit/media'

@struct = state 'tutor/template/template'

@struct.edit_line.top_menu.items =
  'Описание'           : '#'
  'Предметы и условия' : '#'

@struct.edit_line.top_menu.active_item = 'Описание'


@struct.sub_top_menu =
  'Общие'       : '#'
  'Контакты'    : '#'
  'Образование' : '#'
  'Карьера'     : '#'
  'О себе'      : '#'
  'Медиа'       : '/editing/media'

@struct.sub_top_menu = module 'tutor/template/menu/sub_top_menu'

@struct.sub_top_menu.active_item = 'Медиа'

@struct.content = module 'tutor/edit/description/media':
  photos : [
    module 'mime/photo' :
      src : '#'

    module 'mime/photo' :
      src : '#'

    module 'mime/photo' :
      src : '#'

  ]
  video : module 'mime/video' :
    src : '#'

  help : module 'help_block'


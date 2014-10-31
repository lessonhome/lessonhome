@route = '/tutor/edit/media'

@struct = state 'tutor/template/template'

@struct.edit_line.top_menu.items =
  'Описание'           : '#'
  'Предметы и условия' : '#'

@struct.edit_line.top_menu.active_item = 'Описание'


@struct.sub_top_menu?.items =
  'Общие'       : '#'
  'Контакты'    : '#'
  'Образование' : '#'
  'Карьера'     : '#'
  'О себе'      : '#'
  'Медиа'       : '/edit/media'

@struct.sub_top_menu?.active_item = 'Медиа'

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


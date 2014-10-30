@route = '/tutor/editing/media'

@struct = state 'tutor/editing/template'

@struct.content.menu.items = {
  'Общие'
  'Контакты'
  'Образование'
  'Карьера'
  'О себе'
  'Медиа' : '/tutor/editing/media'
}

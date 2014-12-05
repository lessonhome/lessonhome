
class @main extends template 'tutor/template/template'
  route : '/tutor/profile'
  tree : ->
    content : module 'tutor/profile':
      photo : module 'mime/photo' :
        src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
      progress : module 'tutor/profile/description/progress' :
        progress : '56%'
      name : 'Артемий Дудко'
      personal_data : module 'tutor/profile/info_block' :
        section :
          'Дата рождения :': '11.11.11'
          'Статус :': 'Профессор'
          'Город :': 'Москва'
          'Опыт репетиторства :': '2 года'
          'Количество учеников :': '5'
          'Место работы :': 'Кооператив сосулька'

      contacts : module 'tutor/profile/info_block' :
        section :
          'Телефон :'     : '11.11.11'
          'Почта :'       : 'yandex@rambler.ru'
          'Скап :'        : 'baklane'
          'Личный сайт :' : 'prepod.ru'

      education : module 'tutor/profile/info_block' :
        section :
          'ВУЗ :'          : '11.11.11'
          'Фаультет :'     : 'yandex@rambler.ru'
          'Город :'        : 'bakla'
          'Кафедра сайт :' : 'prepod.ru'
          'Статус :'       : 'prepod.ru'
          'Год выпуска: :' : 'prepod.ru'

      private : module 'tutor/profile/description/private' :
        text : 'О себеО себеО себеО себеО себеО себеО себеО себеО себе
            О себеО себеО себеО себеО себеО себеО себеО себеО себеО себеО
            О себеО себеО себеО себеО себеО себеО себеО себеО себеО себе:'
      media : module 'tutor/profile/description/media' :
        photo1 : module 'mime/photo' :
          src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
        photo2 : module 'mime/photo' :
          src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
        video : module 'mime/video' :
          src : 'http://cs10490.vk.me/u168292091/a_fc7a117a.jpg'
      line : module 'tutor/template/separate_line':
        type : 'horizon'
  init : ->
    @parent.tree.left_menu.setActive 'Анкета'


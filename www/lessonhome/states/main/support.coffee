
class @main extends @template '../main'
  route : '/support'
  model : 'main/registration'
  title : "Помощь"
  access : ['other','pupil','tutor']
  tags: ['support']
  tree : =>
    content: @module '$' :
      user_tutor: @module 'link_button' :
        selector: 'ways_block_start'
        text: 'Я РЕПЕТИТОР'
      user_pupil: @module 'link_button' :
        selector: 'ways_block_start'
        text: 'ИЩУ РЕПЕТИТОРА'
      support_block_pupil: @module '../tutor/support' :
        selector   : 'pupil'
        btn_attach : @module 'tutor/header/elem_attach' :
          trigger : 'Отсавить заявку'
        question   : @module 'tutor/forms/input'  :
          selector: 'support'
        ask_button : @module 'tutor/button' :
          text     : 'ЗАДАТЬ ВОПРОС'
          selector : 'support'
      support_block_tutor: @module '../tutor/support' :
        selector   : 'tutor_support'
        question   : @module 'tutor/forms/input'  :
          selector: 'support'
        ask_button : @module 'tutor/button' :
          text     : 'ЗАДАТЬ ВОПРОС'
          selector : 'support'
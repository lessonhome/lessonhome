@route = '/tutor/reviews'

@struct = state 'tutor/template_home'

@struct.content = module 'tutor/profile/review':
  photo : module 'mime/photo' :
    src : '#'
  user_name : 'Аркадий Аркадиевич'
  text : 'Артёмка хорош!'
  review_created_date : '#'


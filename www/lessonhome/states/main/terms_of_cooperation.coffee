
class @main extends @template './main_tutor'
  route : '/terms_of_cooperation'
  model : 'main/first_step.2'
  title : "условия оказания информационных услуг"
  access : ['tutor', 'pupil', 'other']
  tree : ->
    popup : @module '$'
    popup_close_href: '/main_tutor'

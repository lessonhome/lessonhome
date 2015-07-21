

class @main
  route : '/thanks_for_registration'
  model   : 'main/email_illu_copy'
  title : "Благодарственное письмо за регистрацию"
  access : ['other','pupil', 'tutor']
  tree : =>  @module '$' :
    name: 'Сергей Александрович'
    login: 'serega_aleksandrovich'

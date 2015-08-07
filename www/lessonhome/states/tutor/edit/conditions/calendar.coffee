class @main extends @template '../edit_conditions'
  route : '/tutor/edit/calendar'
  model   : 'tutor/edit/conditions/calendar'
  title : "редактирование календарь"
  tags : -> 'edit: conditions'
  access : ['tutor']
  forms : [{'tutor':['calendar']}]
  redirect : {
    'other' : '/enter'
    'pupil' : '/enter'
  }
  tree  : =>
    selector : 'calendar'
    menu_condition  : 'edit: conditions'
    active_item : 'Календарь'
    tutor_edit  : @module '$'  :
      calendar    : @module 'new_calendar' :
        selector  : 'tutor_profile'
        click_ability: true
        value     : $form : tutor : 'calendar'
      #hint       : @module 'tutor/hint_dz' :
      #  selector  : 'small'
      #  text      : 'Поскольку'
  init  :=>
    @parent.parent.tree.content.possibility_save_button = true         # exception property, not this save button in state

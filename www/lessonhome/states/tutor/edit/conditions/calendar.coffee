class @main extends @template '../edit_conditions'
  route : '/tutor/edit/calendar'
  model   : 'tutor/edit/conditions/calendar'
  title : "редактирование календарь"
  tags : -> 'edit: conditions'
  access : ['tutor']
  forms : [{'tutor':['calendar']}]
  redirect : {
    'other' : 'main/first_step'
    'pupil' : 'main/first_step'
  }
  tree  : =>
    menu_condition  : 'edit: conditions'
    active_item : 'Календарь'
    tutor_edit  : @module '$'  :
      calendar    : @state 'calendar'  :
        selector  : 'advance_filter edit'
        value     : $form : tutor : 'calendar'
      #hint       : @module 'tutor/hint_dz' :
      #  selector  : 'small'
      #  text      : 'Поскольку'
  init  :=>
    @parent.parent.tree.content.possibility_save_button = false         # exception property, not this save button in state

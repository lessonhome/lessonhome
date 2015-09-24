class @main
  tree : => @module '$' :
    price : @module 'tutor/forms/input' :
      selector   : 'fast_bid'
    group_people : @module 'tutor/forms/drop_down_list' :
      selector : 'first_reg1'
      self     : true
      default_options     : {
        '0': {value: '0', text: 'не проводятся'},
        '1': {value: '1', text: '2-4 ученика'},
        '2': {value: '2', text: 'до 8 учеников'},
        '3': {value: '3', text: 'от 10 учеников'}
      }
      $form : tutor : 'subject.groups.0.description' : (val)-> val || 'не проводятся'
    selector  : 'first_reg'
    self      : true
    default_options     : {
      '0': {value: '0', text: 'не проводятся'},
      '1': {value: '1', text: '2-4 ученика'},
      '2': {value: '2', text: 'до 8 учеников'},
      '3': {value: '3', text: 'от 10 учеников'}
    }
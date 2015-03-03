

class @main
  route : '/test'
  model   : 'main/first_step'
  title : "выберите предмет"
  tree : => module 'tutor/forms/select_sets' :
    default_options: [
      {value: 'math', text: 'математика'},
      {value: 'algebra', text: 'алгебра'},
      {value: 'arithmetic', text: 'арифметика'},
      {value: 'anatomy', text: 'анатомия'}
    ]
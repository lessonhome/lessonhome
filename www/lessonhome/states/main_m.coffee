prem_rep = [30178,56798,62627,67074,6788,83325,102669,105527,88065,101643,53526,156219,
            13339,95731,80234,153044,112002,112477,130,81323,32380,33875,9658,51307,113760,55,
            137003,102002,69,119809,18286,121193,146399,55050,94487,149780,143187,76476,297,
            109591,68236,60292,104672,21457,83976,133244,130953]
class @main extends @template 'lp'
  route : '/'

  model : 'main_m'
  title : "LessonHome - Главная страница"
  tags   : [ 'tutor:reports']
  access : ['other']
  redirect : {
  }
  tree : =>
    filter = @const('filter')
    content : @module '$':
      subject_list: filter.subjects
      training_direction : filter.course
      value : $urlform : pupil: ''
      reviews : $defer : =>

        return []

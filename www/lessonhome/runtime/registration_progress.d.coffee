

@get = =>
  p = [
    @$status 'tutor_prereg_1'
    @$status 'tutor_prereg_2'
    @$status 'tutor_prereg_3'
    @$status 'tutor_prereg_4'
  ]
  p = yield Q.all p
  for i in [3..0]
    return i+1 if p[i] == true
  return 0




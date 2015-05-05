


class @main
  constructor : ->
  show : =>
    @register 'diff'
  
  match : (text,word,from=0,to=0.5,count=20)=>#,t1=0.8,t2=t1,d1=1000,d2=0)=>
    ntext = @js.toEn text
    nword = @js.toEn word
    if ntext.length < nword.length
      _t    = ntext
      ntext = nword
      nword = _t
    if nword.length == 0
      return 0
    ###
    unless d?
      d = 0
      l = nword.length
      d = 1 if l > 1
      d = 2 if l > 3
      d = 3 if l > 6
      d = 4 if l > 8
      d = 5 if l > 11
    ###
    dmp = new @js.diff_match_patch()
    dmp.Match_Distance  = 100
    for i in [0..count]
      th = from+(to-from)*i/count
      dmp.Match_Threshold = th
      m = dmp.match_bitap_ ntext,nword,0
      if m >= 0
        break
    if m < 0
      th = -1
    #console.log 'm',th,m,ntext,nword,ntext.substring m,m+nword.length
    return th

    dmp1 = new @js.diff_match_patch()
    dmp1.Match_Distance = d1
    dmp1.Match_Threshold = t1
    m = dmp1.match_main ntext,nword,0
    console.log 'm',m,ntext,nword,ntext.substring m,m+nword.length
    unless m < 0
      dmp2 = new @js.diff_match_patch()
      dmp2.Match_Distance = d2
      dmp2.Match_Threshold = t2
      m2 = dmp1.match_main ntext,nword,m
      console.log 'm2',m2,ntext,nword,ntext.substring m2,m2+nword.length
      unless m2<0
        return true
    return false

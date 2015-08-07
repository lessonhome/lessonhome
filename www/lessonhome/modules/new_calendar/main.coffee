
class @main extends EE
  Dom : =>
    @click_day  = @found.click_day

  show : =>
    if @tree.click_ability
      for val in @click_day
        do (val)=>
          val = $ val
          val.on 'click', => @chose_day val


  chose_day : (val)=>
    val.toggleClass 'active_day'
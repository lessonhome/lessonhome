
class @main extends EE
  Dom : =>
    @click_day  = @found.click_day
    @arr = {}
    @tree.value ?= {}
    unless @tree.click_ability
      @dom.find('.click_day').addClass 'noclick'
    for i in [1..7] then for j in [1..3]
      @tree.value[''+i+j] ?= false
      d = @arr[''+i+j] = $ @click_day[(j-1)*7+i-1]
      do (d,i,j)=> d.click =>
        return if @tree.click_ability == false
        @choose_day d,i,j
    console.log @arr

  show : =>
    @setValue()
    ###
    if @tree.click_ability
      for val in @click_day
        do (val)=>
          val = $ val
          val.on 'click', => @chose_day val
    ###
  setValue : (value={})=>
    @tree.value ?= {}
    @tree.value[key] = val for key,val of value
    for i in [1..7] then for j in [1..3]
      @choose_day @arr[''+i+j],i,j,@tree.value[''+i+j]
  getValue : => @tree.value
  choose_day : (d,i,j,state)=>
    emit = true
    emit = false if state?
    state ?= !(d.hasClass 'active')
    unless state
      d.removeClass 'active'
      @tree.value[''+i+j] = false
    else
      d.addClass 'active'
      @tree.value[''+i+j] = true
    @emit 'change' if emit

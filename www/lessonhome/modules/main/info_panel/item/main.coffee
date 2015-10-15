
#Feel.urlData.set('mainFilter',{'subject':['математика']})
#11:54:45
#yield Feel.urlData.set('mainFilter',{'subject':['математика']})
#yield Feel.go('/second_step')


class @main
  constructor : ->
    $W @
  Dom: =>
    @items = @found.item
  show : =>
    for val in @items
      val = $ val
      do (val)=>
        val.on 'click', => Q.spawn =>
          console.log val.text()
          yield Feel.urlData.set('mainFilter',{'subject':[val.text()]})
          yield Feel.go('/second_step')

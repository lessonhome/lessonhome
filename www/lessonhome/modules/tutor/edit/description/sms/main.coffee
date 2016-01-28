class @main
  constructor : ->
    $W @
    @active = true
  show : =>
    @tree.send_message.class.on 'submit',=>
      console.log 'submit'
      @send()
  send : =>
    return unless @active
    @found.status.text 'отправка...'
    @active = false
    try
      data = yield Feel.sms [
        phone : @tree.phone.class.getValue()
        text  : @tree.text.class.getValue()
      ]
      text = ''
      if data?[0]?.messages?[0]?.status?
        for st in data
          text += 'status:         '+st.status+'\n'
          text += 'message:    '+st.messages[0].status+'\n\n'
      else
        text = JSON.stringify(data,4,4)
      text = "Ошибка. Возможно вы не админ?" unless text
      text = text.replace /\ /gmi,'&nbsp;'
      @found.status.html text.replace /\n/gmi,'<br>'
    catch e
      #@found.status.text
      text = ""+e+"\n\n"+JSON.stringify(e,4,4)
      text = "Ошибка. Возможно вы не админ?" unless text
      text = text.replace /\ /gmi,'&nbsp;'
      @found.status.html text.replace /\n/gmi,'<br>'
    @active = true
    

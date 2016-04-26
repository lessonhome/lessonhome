class @main
  constructor: ->
    $W @
  Dom : =>
    @chatBox = @found.chat_box
    @messageTextarea = @found.message_textarea
    @messageSend = @found.message_send
    @reinit()
    #@chatBox.scrollTop(@chatBox.get(0).scrollHeight)

    #плагин для клевой полосы прокрутки, есть баг, мигает при нажатии
    #элементы, пока не разберусь, подключать нет смысла
    #@chatBox.niceScroll({
    #cursorcolor: '#889395',
    # cursorwidth: '7px',
    # autohidemode: false
    #})

    @userName = 'Артем'
  reinit : =>
    @chatBox.scrollTop(@chatBox.get(0).scrollHeight)
  show  : =>
    @messageSend.on 'click', @sendFromBox
    
    Feel.sio.io.on "chatPush:#{@tree.value.chat.hash}",@chatPush
  chatPush : (msg)=>
    @appendMessage msg
  sendFromBox : =>
    userMessage = @messageTextarea.val()
    msg =
      type : 'pupil'
      time : new Date().getTime()
      text : userMessage
    Feel.sio.io.emit 'chatPush',@tree.value.chat.hash,msg
    #@appendMessage msg
    @messageTextarea.val ''

  appendMessage : (message) =>
    message = @js.parseMessage message,@tree.value.pupil,@tree.value.moderator
    messageTemplate = '<div class="mod-lp-personal_cabinet-chat--m-message '+message.type+'"><div class="meta">'
    if message.from?.name
      messageTemplate += '<span class="name">' + message.from.name  + '</span>'
      
    messageTemplate += '<span class="date">' + message.timestr + '</span></div><div class="text">' + message.text + '</div></div>'
    @chatBox.append messageTemplate
    @chatBox.scrollTop(@chatBox.get(0).scrollHeight)


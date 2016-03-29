class @main
  constructor: ->
    $W @
  Dom : =>
    @chatBox = @found.chat_box
    @messageTextarea = @found.message_textarea
    @messageSend = @found.message_send

    #плагин для клевой полосы прокрутки, есть баг, мигает при нажатии
    #элементы, пока не разберусь, подключать нет смысла
    #@chatBox.niceScroll({
    #cursorcolor: '#889395',
    # cursorwidth: '7px',
    # autohidemode: false
    #})

    @userName = 'Артем'

  show  : =>
    @messageSend.on 'click', =>
      @userMessage = @messageTextarea.val()
      @appendMessage({})

  appendMessage : (message) =>
    @messageTemplate = '<div class="mod-lp-personal_cabinet-chat--m-message"><div class="meta"><span class="name">' + message.from.name  + '</span><span class="date">' + message.time + '</span></div><div class="text">' + message.text + '</div></div>'
    @chatBox.append @messageTemplate
    @messageTextarea.val ''


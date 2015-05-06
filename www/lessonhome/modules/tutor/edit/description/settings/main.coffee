class @main
  Dom   : =>
    @hint = @found.hint
    @close_block = @found.close_block
    # notice
    @new_orders_toggle = @tree.new_orders_toggle.class
    @notice_sms_checkbox = @tree.notice_sms_checkbox.class
    @notice_email_checkbox = @tree.notice_email_checkbox.class
    @callback_toggle = @tree.callback_toggle.class
    @callback_comment = @tree.callback_comment.class
    @save_button_notice = @tree.save_button_notice.class
    # phone
    @new_login = @tree.new_login.class
    # email
    @new_email = @tree.new_email.class
    # password
    @old_password = @tree.old_password.class
    @new_password = @tree.new_password.class
    @confirm_password = @tree.confirm_password.class
    @save_button_password = @tree.save_button_password.class

  show  : =>
    @callback_toggle = @tree.callback_toggle.class
    @callback_toggle.on 'sec_active', =>
      @hint.show()

    @close_block.on 'click', =>
      @hint.hide()

    @save_button_notice.on 'submit', @b_save_notice
    @save_button_password.on 'submit', @b_save_password

  b_save_notice : =>
    @save_notice().then (success)=>
      if success
        ###
        @$send('./save',@progress).then ({status})=>
          if status=='success'
            return true
        ###
        console.log 'IS SEND!!!'
        $('body,html').animate({scrollTop:0}, 500)
        #@changes_field.fadeIn()
        return true
    .done()

  save_notice : => Q().then =>
    if @check_form()
      return @$send('./save_notice',@getDataNotice())
      .then @onReceive
    else
      return false

  b_save_password : =>
    @save_password().then (success)=>
      if success
        console.log 'IS SEND!!!'
        $('body,html').animate({scrollTop:0}, 500)
        #@changes_field.fadeIn()
        return true
    .done()

  save_password : => Q().then =>
    if @check_password()
      return @$send('./save_password',@getDataPassword())
      .then @onReceive
    else
      return false

  onReceive : ({status,errs,err})=>
    if err?
      errs?=[]
      errs.push err
    if status=='success'
      return true
    if errs?.length
      for e in errs
        @parseError e
    return false

  check_form : =>
    return true
    #errs = @js.check @getData()
    #for e in errs
     # @parseError e
    #return errs.length==0

  check_password : =>
    errs = @js.checkPassword @getData()

  getDataNotice : =>
    get_notifications = []
    if @notice_sms_checkbox.getValue() then get_notifications.push 'sms'
    if @notice_email_checkbox.getValue() then get_notifications.push 'email'
    return {
      new_orders: @new_orders_toggle.getValue()
      get_notifications: get_notifications
      call_operator_possibility: @callback_toggle.getValue()
      callback_comment: @callback_comment.getValue()
    }

  getDataPassword : =>
    return {
      old : @old_password.getValue()
      new : @new_password.getValue()
      confirm : @confirm_password.getValue()
    }

  parseError : (err)=>
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    #switch err
    #empty
    #correct
      #else
       # alert 'die'
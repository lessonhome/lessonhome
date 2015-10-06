class @main
  Dom : =>
    @btn = @tree.btn_send.class
    @name = @tree.field_name.class
    @phone = @tree.field_phone.class
  show : =>
    @btn.on 'submit', =>
      console.log @name.getValue(), @phone.getValue()
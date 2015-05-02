

class @main
  show : =>
    @success    = @tree.success_button.class
    @fail       = @tree.fail_button.class

    @success  .on 'active', => @fail      .disable()
    @fail     .on 'active', => @success   .disable()



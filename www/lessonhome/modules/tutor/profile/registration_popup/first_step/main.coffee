

class @main
  show : =>
    @man    = @tree.sex_man.class
    @woman  = @tree.sex_woman.class

    @man  .on 'active', => @woman .disable()
    @woman.on 'active', => @man   .disable()
    

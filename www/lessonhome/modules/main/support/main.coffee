
class @main
  Dom: =>
    @start_block = @found.start_block
    @support_block_tutor = @found.support_block_tutor
    @support_block_pupil = @found.support_block_pupil
    @user_tutor = @found.user_tutor
    @user_pupil = @found.user_pupil
  show: =>
    $(@user_tutor).on 'click', =>
      @start_block.hide()
      @support_block_tutor.show()

    $(@user_pupil).on 'click', =>
      @start_block.hide()
      @support_block_pupil.show()
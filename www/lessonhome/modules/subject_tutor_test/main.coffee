class @main
  show : =>
    $('.place_block').on 'click', '.place label, .chose_group label', ->
      block = $(this).closest('.price_block, .group_block').find '.hour_block:first, .active_block:first'
      if $(this).is '.active'
        block.slideDown 200
      else
        block.slideUp 200
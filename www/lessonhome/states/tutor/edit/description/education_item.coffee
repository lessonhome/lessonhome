class @main
  forms : [{person:['education']}]
  tree : => @module 'tutor/edit/description/education' :
    add_button     : @module 'tutor/button' :
      selector  : 'edit_save'
    test : @module 'tutor/forms/adds_blocks' :
      element : @module 'tutor/forms/adds_blocks/element' :
        title_element : @module 'tutor/forms/drop_down_list' :
          placeholder: 'Введите название ВУЗа'
          selector  : 'third_reg'
          $form : person : 'education.0.name'
          self  : true
          smart : true
        content_form: @module 'tutor/edit/description/education/form' :
          country       : @module 'tutor/forms/drop_down_list' :
            items : ['Россия','Белоруссия','Казахстан','Киргизия','Абхазия','Украина','Молдавия','Румыния','Норвегия','Латвия']
            selector  : 'first_reg1'
            value : $form : person : 'education.0.country'
            self  : true
            smart : true
          city          : @module 'tutor/forms/drop_down_list' :
            items : ['Москва', 'Санкт-Петербург', 'Новосибирск', 'Екатеринбург', 'Нижний Новгород', 'Казань', 'Самара', 'Челябинск', 'Омск','Ростов-на-Дону', 'Уфа', 'Красноярск', 'Пермь', 'Волгоград', 'Воронеж', 'Саратов', 'Краснодар', 'Тольятти', 'Тюмень', 'Ижевск','Барнаул', 'Ульяновск', 'Иркутск', 'Владивосток', 'Ярославль', 'Хабаровск', 'Махачкала', 'Оренбург', 'Томск', 'Кемерово', 'Рязань', 'Астрахань', 'Набережные Челны', 'Пенза', 'Липецк']
            selector  : 'first_reg1'
            $form : person : 'education.0.city'
            self  : true
            smart : true
          faculty       : @module 'tutor/forms/drop_down_list' :
            selector  : 'first_reg1'
            $form : person : 'education.0.faculty'
            self  : true
            smart : true
          chair         : @module 'tutor/forms/drop_down_list' :
            selector  : 'first_reg1'
            $form : person : 'education.0.chair'
            self  : true
            smart : true
          qualification : @module 'tutor/forms/drop_down_list' :
            selector  : 'first_reg1'
            $form : person : 'education.0.qualification'
            self  : true
            smart : true
          period_education : @module 'tutor/forms/period' :
            from : @module 'tutor/forms/drop_down_list' :
              self : false
              selector  : 'first_reg1'
              placeholder : 'от'
              $form : person : 'education.0.period.start'
            till : @module 'tutor/forms/drop_down_list' :
              self : false
              selector  : 'first_reg1'
              placeholder : 'до'
              $form : person : 'education.0.period.end'
#          learn_from    : @module 'tutor/forms/drop_down_list'  :
#            selector    : 'first_reg_from'
#            placeholder : 'с'
#            $form : person : 'education.0.period.start'
#            self  : true
#            smart : true
#          learn_till    : @module 'tutor/forms/drop_down_list'  :
#            selector    : 'first_reg_till'
#            placeholder : 'до'
#            $form : person : 'education.0.period.end'
#            self  : true
#            smart : true
          comment : @module 'tutor/forms/textarea' :
            selector  : 'first_reg1'
            height : '117px'
            $form : person : 'education.0.comment'
      add_button : @module 'tutor/button' :
        text : 'Добавить образование'
    item : @module 'tutor/edit/description/education/item' :
      country       : @module 'tutor/forms/drop_down_list' :
        
        items : ['Россия','Белоруссия','Казахстан','Киргизия','Абхазия','Украина','Молдавия','Румыния','Норвегия','Латвия']
        selector  : 'first_reg1'
        value : $form : person : 'education.0.country'
        self  : true
        smart : true
      city          : @module 'tutor/forms/drop_down_list' :
        items : ['Москва', 'Санкт-Петербург', 'Новосибирск', 'Екатеринбург', 'Нижний Новгород', 'Казань', 'Самара', 'Челябинск', 'Омск','Ростов-на-Дону', 'Уфа', 'Красноярск', 'Пермь', 'Волгоград', 'Воронеж', 'Саратов', 'Краснодар', 'Тольятти', 'Тюмень', 'Ижевск','Барнаул', 'Ульяновск', 'Иркутск', 'Владивосток', 'Ярославль', 'Хабаровск', 'Махачкала', 'Оренбург', 'Томск', 'Кемерово', 'Рязань', 'Астрахань', 'Набережные Челны', 'Пенза', 'Липецк']
        selector  : 'first_reg1'
        $form : person : 'education.0.city'
        self  : true
        smart : true
      university    : @module 'tutor/forms/drop_down_list' :
        selector  : 'first_reg1'
        $form : person : 'education.0.name'
        self  : true
        smart : true
      faculty       : @module 'tutor/forms/drop_down_list' :
        selector  : 'first_reg1'
        $form : person : 'education.0.faculty'
        self  : true
        smart : true
      chair         : @module 'tutor/forms/drop_down_list' :
        selector  : 'first_reg1'
        $form : person : 'education.0.chair'
        self  : true
        smart : true
      qualification : @module 'tutor/forms/drop_down_list' :
        selector  : 'first_reg1'
        $form : person : 'education.0.qualification'
        self  : true
        smart : true
      period_education : @module 'tutor/forms/period' :
        from : @module 'tutor/forms/drop_down_list' :
          self : false
          selector  : 'first_reg1'
          placeholder : 'от'
          $form : person : 'education.0.period.start'
        till : @module 'tutor/forms/drop_down_list' :
          self : false
          selector  : 'first_reg1'
          placeholder : 'до'
          $form : person : 'education.0.period.end'
      learn_from    : @module 'tutor/forms/drop_down_list'  :
        selector    : 'first_reg_from'
        placeholder : 'с'
        $form : person : 'education.0.period.start'
        self  : true
        smart : true
      learn_till    : @module 'tutor/forms/drop_down_list'  :
        selector    : 'first_reg_till'
        placeholder : 'до'
        $form : person : 'education.0.period.end'
        self  : true
        smart : true
      comment : @module 'tutor/forms/textarea' :
        selector  : 'first_reg1'
        height : '117px'
        $form : person : 'education.0.comment'


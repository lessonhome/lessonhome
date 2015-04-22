
class @main
  Dom : =>
    @out_err_country  = @found.out_err_country
    @out_err_city     = @found.out_err_city
    @out_err_area     = @found.out_err_area

  show: =>
    # drop_down_list
    @country    = @tree.country.class
    @city       = @tree.city.class
    @area       = @tree.area.class
    # input
    @near_metro = @tree.near_metro.class
    @street     = @tree.street.class
    @house      = @tree.house.class
    @building   = @tree.building.class
    @flat       = @tree.flat.class

    # drop_down_list focus TODO: make in drop_down_list clear_err_effect on element after focus and start writing, same input
    @country.on     'focus',  => @clearOutErr @out_err_country, @country
    @city.on        'focus',  => @clearOutErr @out_err_city,    @city
    @area.on        'focus',  => @clearOutErr @out_err_area,    @area



    @bSave = @tree.save_button.class
    @bSave.on 'submit', @next

  next : =>
    @save?().then (success)=>
      if success
        @bSave.submit()
    .done()

  save : => Q().then =>
    if @check_form()
      return @$send('./save',@getData())
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
    errs = @js.check @getData()
    if !@country.exists() && @country.getValue().length!=0
      errs.push 'bad_country'
    if !@city.exists() && @city.getValue().length!=0
      errs.push 'bad_city'
    if !@area.exists() && @area.getValue().length!=0
      errs.push 'bad_area'


  getData: =>
    return {
      country: @country.getValue()
      city: @city.getValue()
      area: @area.getValue()
      street: @street.getValue()
      house: @house.getValue()
      building: @building.getValue()
      flat: @flat.getValue()
      metro: @near_metro.getValue()
    }

  parseError : (err)=>
    switch err
      # short
      when "short_near_metro"
        @near_metro.showError "Слишком короткое название"
      when "short_street"
        @street.showError "Слишком короткое название"
      when "short_house"
        @house.showError "Слишком короткое название"
      when "short_building"
        @building.showError "Слишком короткое название"
      when "short_flat"
        @flat.showError "Слишком короткое название"

      #long
      when "long_near_metro"
        @near_metro.showError "Слишком длинное название"
      when "long_street"
        @street.showError "Слишком длинное название"
      when "long_house"
        @house.showError "Слишком длинное название"
      when "long_building"
        @building.showError "Слишком длинное название"
      when "long_flat"
        @flat.showError "Слишком длинное название"

      # correct
      when "bad_country"
        @outErr "Выберите значение из списка", @out_err_country, @country
      when "bad_city"
        @outErr "Выберите значение из списка", @out_err_city, @city
      when "bad_area"
        @outErr "Выберите значение из списка", @out_err_area, @area
      # empty
      when "empty_country"
        @outErr "Выберите страну", @out_err_country, @country
      when "empty_city"
        @outErr "Выберите город", @out_err_city, @city
      when "empty_area"
        @outErr "Выберите район", @out_err_area, @area

      when "empty_near_metro"
        @near_metro.showError "Заполните поле"
      when "empty_street"
        @street.showError "Заполните поле"
      when "empty_house"
        @house.showError "Заполните поле"
      when "empty_building"
        @building.showError "Заполните поле"
      when "empty_flat"
        @flat.showError "Заполните поле"


  outErr : (err, err_el, el) =>
    if el instanceof Array
      for _el in el
        _el.err_effect()
    else
      el.err_effect()
    err_el.text err
    setTimeout =>
      err_el.show()
    , 100

  clearOutErr : (err_el ,el) =>
    el.clean_err_effect()
    err_el.hide()
    err_el.text('')

class @main
  show: =>
    @country = @tree.country.class
    @city = @tree.city.class
    @area = @tree.area.class
    @near_metro = @tree.near_metro.class
    @street = @tree.street.class
    @house = @tree.house.class
    @building = @tree.building.class
    @flat = @tree.flat.class

  save : => Q().then =>
    if @check_form()
      return @$send('./save',@getData())
      .then ({status,errs})=>
      if status=='success'
        return true
      if errs?.length
        @parseError errs
      return false
    else
      return false

  check_form : =>
    errs = []
    return true

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

@check = (f)=>
  errs = []
  # short
  if f.metro.length < 3
    errs.push "short_near_metro"
  if f.street.length < 3
    errs.push "short_street"
  if f.house.length < 3
    errs.push "short_house"
  if f.building.length < 3
    errs.push "short_building"
  if f.flat.length < 3
    errs.push "short_flat"

  # long
  if f.metro.length > 100
    errs.push "long_near_metro"
  if f.street.length > 100
    errs.push "long_street"
  if f.house.length > 100
    errs.push "long_house"
  if f.building.length > 100
    errs.push "long_building"
  if f.flat.length > 100
    errs.push "long_flat"


  # empty
  if f.metro.length == 0
    errs.push "empty_near_metro"
  if f.street.length == 0
    errs.push "empty_street"
  if f.house.length == 0
    errs.push "empty_house"
  if f.building.length == 0
    errs.push "empty_building"
  if f.flat.length == 0
    errs.push "empty_flat"

  if f.country.length == 0
    errs.push "empty_country"
  if f.city.length == 0
    errs.push "empty_city"
  if f.area.length == 0
    errs.push "empty_area"
  return errs



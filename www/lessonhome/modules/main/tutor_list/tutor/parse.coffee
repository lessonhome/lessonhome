

#metro = Feel.const('metro').metro

@parse = (value)->
  value.name = "#{value?.name?.first ? ""} #{value?.name?.middle ? ""}"

  console.log value

  return value
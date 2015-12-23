class @F2V
  constructor: ->
    @curr_sum = null
  $transactions : (data) ->
    result = {}
    return result unless data?
    _date = null
    curr_sum = null
    for k, v of data
      result[k] = {
        date: v.date
        type: v.type
        value: v.value
        residue : v.residue
      }

      if v.type == "fill"
        _date ?= v.date

        if v.date > _date
          _date = v.date
          curr_sum = v.residue

    @curr_sum = curr_sum
    return result

  $current_sum : (data) ->
    return @curr_sum if @curr_sum?

    _date = null
    curr_sum = null
    for k, v of data

      if v.type == "fill"
        _date ?= v.date

        if v.date > _date
          _date = v.date
          curr_sum = v.residue

    @curr_sum = curr_sum
    return @curr_sum || 0
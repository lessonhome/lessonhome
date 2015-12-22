class @F2V
  $transactions : (data) ->
    result = {}
    console.log 'Критик', data
    return result unless data?
    for k, v of data
      result[k] = {
        date: v.date
        type: v.type
        value: v.value
        residue : v.residue
      }
    return result
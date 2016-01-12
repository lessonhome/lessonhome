sort_date = (a,b) -> return new Date(b.date) - new Date(a.date)

class @F2V
  $transactions : (data) ->
    result = []
    for id, val of data.transactions
      val.value = val.value?.toFixed?(2)
      val.residue = val.residue?.toFixed?(2)
      result.push val
    result.sort sort_date
    return result
  $current_sum : (data) -> if data.residue? then data.residue.toFixed(2) else '0.00'

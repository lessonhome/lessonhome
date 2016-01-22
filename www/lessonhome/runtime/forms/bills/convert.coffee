sort_date = (a,b) -> return new Date(b.date) - new Date(a.date)

class @F2V
  $transactions : (data) ->
    result = []
    for number, val of data.transactions
      val.number = number
      result.push val
    result.sort sort_date
    residue = 0

    if result.length
      for i in [result.length-1..0]

        if result[i].status == 'success'

          switch result[i].type
            when 'fill' then residue += result[i].value
            when 'pay' then residue -= result[i].value
          result[i].residue = residue.toFixed?(2)

        result[i].value = result[i].value.toFixed?(2)

    return result
  $current_sum : (data) -> if data.residue? then data.residue.toFixed(2) else '0.00'
  $toPay: (data) -> if data.residue? and data.residue < 0 then Math.abs(data.residue) else undefined



default_prepare = {
  float : (val) -> parseFloat(val)
  integer : (val) -> parseInt(val)
  string : (val) -> '' + val
  bool : (val)-> !!val
  arr : (foo) ->
    return (val) ->
      result = []
      for v in val then result.push foo(v)
      return result
  obj : (foo) ->
    return (val) ->
      result = {}
      for own key, v of val then result[key] = foo(v)
      return result
}

default_check = {
  require : (val) -> val?
  isEmpty : (val) -> val.length == 0
}


#EXAMPLE
#fields = [
#  {
#    name: 'price'
#    prep: 'float'
#  }
#  {
#    name: ['status', 'subjects']
#    prep: 'arr:string'
#  }
#  {
#    name : ['name', 'gender', 'email', 'phone', 'index', 'executor', '_id']
#    prep: 'string'
#  }
#  {
#    name : 'moderate'
#    prep: 'bool'
#  }
#  {
#    name: 'other'
#    prep: (val) ->
#     *some prepare function
#  }
#  {
#    name: 'other_key'
#    attach : [
#      {
#        name : 'attach_key'
#        prep : 'bool'
#      }
#      {
#        name : 'another'
#        prep : ...
#      }
#    ]
#  }
#]



@prepare = (data, fields) =>
  try
    result = {}
    for f in fields
      names = if f.name instanceof Array then f.name else [f.name]
      for n in names when data[n]?

        if f.attach?
          result[n] = @getValue(data[n], f.attach)
        else if f.prep?
          prep = null

          switch typeof(f.prep)
            when 'string'
              prep = f.prep.split(':')

              switch prep.length
                when 1 then prep = default_prepare[prep[0]]
                when 2 then prep = default_prepare[prep[0]]?(default_prepare[prep[1]])
                else prep = null

            when 'function' then prep = f.prep

          throw new Error('bad prepare parameter') unless prep and typeof(prep) is 'function'
          result[n] = prep data[n]

    return result
  catch errs
    console.error Exception errs
    return null

@check = (data, rules) =>

class Check_Patterns
  constructor : ->
    @patterns =
      digits : '^\\d*$'
      alphabet : '^[a-z]*'

  Dom : =>
    @register 'checker'
  check : (pattern, value) ->
    (new RegExp(pattern)).test value

  checkMinMax: (min, val, max) ->
    res1 = min <= val
    res2 = val <= max
    if min? && max?
      return res1 && res2
    if min?
      return res1
    if max?
      return res2
    throw new Error 'required min or max, or both arguments'

  checkDigits : (val) =>
    @check @patterns.digits, val

# Register example
## registering foo
#    @register 'checker', @js.foo
## Using
# Feel.checker()

@main = Check_Patterns

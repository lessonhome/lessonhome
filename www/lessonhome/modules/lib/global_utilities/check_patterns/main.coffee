class @main
  show : ->
    @patterns =
      digits : '^\d*$'
      alphabet : '^[a-z]*'
    @register 'checker'
  check : (pattern, value) ->
    (new RegExp(pattern)).test value

# Register example
## registering foo
#    @register 'checker', @js.foo
## Using
# Feel.checker()
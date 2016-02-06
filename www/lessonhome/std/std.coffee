


class Std
  constructor : -> $W @
  define : (key,object)=>
    throw new Error if @[key]?
    @[key] = object


global.Std = new Std







@checker = ($,value)=>
  typeof value == 'string' &&
  value?.length? &&
  0 <= value.length <= 100



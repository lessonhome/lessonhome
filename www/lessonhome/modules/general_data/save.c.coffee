
check = require "./check"

@handler = ($,data)=>
  errs = check data
  if errs.length
    return {sucess:false,errs:errs}
  return {success:true}
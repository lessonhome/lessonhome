ee = new EE
ee.on 'a',->
ee.once 'a',->
ee.emit 'a'

module.exports = (key)->
  switch key
    when '__serviceName'
      return false
  return true if ee[key]?
  switch key
    when 'init','log','error','_lock','_unlock','_block','_unblock','_single','then'
      return true
  if key.match /^__.*$/
    return true
  return false

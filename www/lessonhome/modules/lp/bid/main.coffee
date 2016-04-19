

class @main
  constructor : ->
  Dom : =>
    @register 'bid'
  save : (o)=>
    o ?= {}
    o.type ?= "bid"
    console.log "bid_helper"
    o.linked ?= yield Feel.urlData.get 'mainFilter','linked'
    {status,errs,err} = yield Feel.jobs.server 'saveBid', o

    return {status,errs,err}





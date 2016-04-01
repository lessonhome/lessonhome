


class @main
  Dom : =>
    try
      yield @initWorker()
    catch e
      console.error 'failed init worker'
      console.error Exception e
  initWorker : =>
    #src = "/js/666/service_worker/worker"
    src = "/service-worker.js"
    unless navigator?.serviceWorker?
      return console.log 'service worker not exists'
    
    @worker = yield navigator.serviceWorker.register(src)
    console.log @worker
    


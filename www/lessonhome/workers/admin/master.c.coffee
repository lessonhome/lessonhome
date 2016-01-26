class MasterAdmin
  constructor : ->
    $W @
    @path = 'www/lessonhome/admin'
    @target = {}
    @config =
      target : {
      }
      task : {}
    @signals = {}
  init : =>
    @jobs = yield Main.service 'jobs'
    yield @loadConfigs()
    yield @solveJobs()
    console.log yield @jobs.solve 'getTargetTypes'
    console.log yield @jobs.solve 'getShortTargets',{name:'tutor'}
  loadConfigs : =>
    readed  = yield _readdirp
      root : "#{@path}/target"
      fileFilter : '*.coffee'
    files = for file in readed.files then file.path.replace /\.coffee$/,''
    #console.log files
    for target in files
      conf =  require "#{process.cwd()}/#{@path}/target/#{target}.coffee"
      @config.target[target] = conf
      conf.short ?= conf.rect
      conf.rect  ?= conf.short
      unless conf.short?
        throw new Error "bad @short in target #{target}"
  solveJobs : =>
    for name,conf of @config.target
      @target[name] = yield @jobs.solve conf.job
      unless @signals[name]
        @signals[name] = true
        do (name,conf)=> Q.spawn => yield @jobs.onSignal conf.signal, => Q.spawn =>
          yield @onTargetChange name
    yield @jobs.listen 'getShortTargets', @jobGetShortTargets
    yield @jobs.listen 'getTargetTypes', @jobGetTargetTypes
  onTargetChange : (name) =>
    @target[name] = yield @jobs.solve @config.target[name].job
  jobGetTaskInfo : =>
    return {
      task : [
        {
          name: '',
          description: ''
        }
      ]
    }
  jobGetTargetTypes : => Object.keys @target
  jobGetShortTargets : ({count, offset, name})=>
    offset ?= 0
    ret = []
    unless @target[name]?
      throw new Error "unknown target with name:#{name}}"
    count ?= @target[name].length - offset
    if offset > @target[name].length
      offset = @target[name].length
    if offset+count > @target[name].length
      count = @target[name].length - offset
    for i in [offset...offset+count]
      target = @target[name][i]
      obj = {}
      for field in conf.short
        obj.type = field.type ? 'text'
        if m = field.value.match /^target\.(.*)$/
          obj.value = _setKey target,m[1]
        else
          obj.value = field.value
      ret.push obj

    return ret



  jobGetHistory : ({count, offset})=>
    return {
      history : [
        {}
        {}
        {}
      ]
    }

  #jobGetLinkedTarget : ({count: 10, offset: 0})=>



module.exports = new MasterAdmin


os = require 'os'

class Services
  constructor : ->
    $W @
    @services = {}
    @startPort = 8900
    @port = @startPort
    @jobs = _Helper 'jobs/main'
  run : =>
    readed  = yield _readdirp
      root : 'www/lessonhome'
      fileFilter : '*.c.coffee'
    files = for file in readed.files then file.path.replace /\.c\.coffee$/,''
    w8for = []
    alone = {'modules/main/preview/tutors':1,'modules/admin/tutors/load':1}
    scope = []
    for file in files
      unless file.match(/^workers\//) || alone[file]
        scope.push file
        continue
      switch file
        when 'workers/jobs/io_client','workers/tutors/load'
          w8for.push (yield @startFiles [file],os.cpus().length,1)...
        else
          w8for.push (yield @startFiles [file])...
    w8for.push (yield @startFiles files,os.cpus().length,4)...

    yield @jobs.solve 'masterServiceManager-runServices',w8for
  startFiles : (files,countProduction=1,countLocal=1)=>
    count = 1
    if _production then count = countProduction
    else count = countLocal
    
    port = @port++
    @services[file] = {port} for file in files
    w8for = []
    for i in [1..count]
      w8for.push ['socket2',{
        files : files
        port : port
      }]
    return w8for

    
  get : => @services
  



module.exports = Services





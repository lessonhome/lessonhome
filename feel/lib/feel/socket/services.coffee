

os = require 'os'

class Services
  constructor : ->
    $W @
    @services = {}
    @startPort = 8900
    @jobs = _Helper 'jobs/main'
  run : =>
    readed  = yield _readdirp
      root : 'www/lessonhome'
      fileFilter : '*.c.coffee'
    files = for file in readed.files then file.path.replace /\.c\.coffee$/,''
    w8for = []
    for file,i in files
      o = @services[file] = {}
      o.port = @startPort+i
      max = 1
      if _production
        max = os.cpus().length
      switch file
        when 'workers/jobs/io_client','workers/tutors/load' then num = max
        else num = 1
      for i in [1..num]
        w8for.push ['socket2',{
          file : file
          port : o.port
        }]

    yield @jobs.solve 'masterServiceManager-runServices',w8for
  get : => @services
  



module.exports = Services





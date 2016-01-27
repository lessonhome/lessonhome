


class Services
  constructor : ->
    $W @
    @services = {}
    @startPort = 8900
  run : =>
    readed  = yield _readdirp
      root : 'www/lessonhome'
      fileFilter : '*.c.coffee'
    files = for file in readed.files then file.path.replace /\.c\.coffee$/,''
    w8for = []
    for file,i in files
      o = @services[file] = {}
      o.port = @startPort+i
      switch file
        when 'workers/jobs/io_client','workers/tutors/load' then num = 8
        else num = 1
      for i in [1..num]
        w8for.push Main.serviceManager.master.runService 'socket2',{
          file : file
          port : o.port
        }
    yield Q.all w8for
  get : => @services
  



module.exports = Services





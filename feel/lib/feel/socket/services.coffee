


class Services
  constructor : ->
    $W @
    @services = {}
    @startPort = 8900
  init : ->
    readed  = yield _readdirp
      root : 'www/lessonhome'
      fileFilter : '*.c.coffee'
    files = for file in readed.files then file.path.replace /\.c\.coffee$/,''
    w8for = []
    for file,i in files
      o = @services[file] = {}
      o.port = @startPort+i
      n = 1
      n = 8 if file.match 'reloadTutor'
      for num in [1..n]
        w8for.push Main.serviceManager.master.runService 'socket2',{
          file : file
          port : o.port
        }
    yield Q.all w8for
  get : => @services
  



module.exports = Services





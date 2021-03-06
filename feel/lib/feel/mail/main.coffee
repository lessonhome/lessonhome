

nodemail = require 'nodemailer'


class Mail
  constructor : ->
    Wrap @
    @templates = {}
    @attachments = {}
  init : ->
    @reload().done()
  reload : =>
    files = yield _readdir process.cwd()+'/www/lessonhome/mails'
    for file in files
      failed = true
      while failed
        failed = yield @prepareCss file
        if failed
          yield Q.delay 1000
          console.error 'mail preloading failed'
      
  prepareCss: (file) =>
    @attachments[file] = []
    images = {}
    
    data = yield _readFile process.cwd()+'/www/lessonhome/mails/'+file
    data = data.toString()

    for image in data.match(/{{.+}}/g)
      image = image.replace(/{|}/g, '')
      continue if images[image]
      images[image] = true
      @attachments[file].push
        filename: image.replace(/(\/.+\/)*/, '')
        path:     process.cwd()+'/www/lessonhome/static'+image
        cid:      image.replace(/(\/.+\/)*/, '').replace(/\..+/, '') + '@lessonhome'
      data = data.replace(
        new RegExp('{{' + image + '}}', 'g'),
        '\'cid:' + image.replace(/(\/.+\/)*/, '').replace(/\..+/, '') + '@lessonhome\''
      )
    
    rb = yield _requestPost
      url : 'http://premailer.dialect.ca/api/0.1/documents'
      form: {html: data}
    if rb[1]? then body = rb[1]
    else      body = rb.body
    return true if (!body?[0]?) || (body[0] is '<')
    
    url = JSON.parse(body)?.documents?.html
    rb = yield _request {url}
    if rb[1]? then body = rb[1]
    else      body = rb.body
    @templates[file] = body
    console.log 'mail: '.magenta+file+' was read from mails to Mail.templates'

  prepare: (data, repls)->
    for key, value of repls
      data = data?.replace?(new RegExp('#{' + key + '}', 'g'), value)
    return data

  send : (template, email, subject, repls) ->
    console.log 'mail: Sending mail to'.yellow, email

    transporter = nodemail.createTransport
      service : 'Gmail'
      auth :
        user : 'support@lessonhome.ru'
        pass : 'cheburashka'

    mailOptions =
      from : 'Лессон Хоум <support@lessonhome.ru>'
      to   : email
      subject : subject
      html: yield @prepare @templates[template], repls
      attachments : @attachments[template]

    info = yield  _invoke transporter, 'sendMail', mailOptions
    
    console.log 'mail: Mail sent'.yellow, info



module.exports = Mail

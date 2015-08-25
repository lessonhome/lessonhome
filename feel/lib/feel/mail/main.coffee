

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
    yield @prepareCss file for file in files
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
    
    response = yield _requestPost
      url : 'http://premailer.dialect.ca/api/0.1/documents'
      form: {html: data}
    return @prepareCss file if response.body[0] is '<'
    
    url = JSON.parse(response.body)?.documents?.html
    response = yield _request {url}
    
    @templates[file] = response.body
    console.log 'mail: '.magenta+file+' was read from mails to Mail.templates'

  prepare: (data, repls)->
    for key, value of repls
      data = data.replace(new RegExp('#{' + key + '}', 'g'), value)
    return data

  send : (template, email, subject, repls) ->
    console.log 'mail: Sending mail to'.yellow, email

    transporter = nodemail.createTransport
      service : 'Gmail'
      auth :
        user : 'support@lessonhome.ru'
        pass : 'Jlth;bvjcnm'

    mailOptions =
      from : 'Лессон Хоум ✔ <support@lessonhome.ru>'
      to   : email
      subject : subject
      html: yield @prepare @templates[template], repls
      attachments : @attachments[template]

    info = yield  _invoke transporter, 'sendMail', mailOptions
    
    console.log 'mail: Mail sent'.yellow, info



module.exports = Mail

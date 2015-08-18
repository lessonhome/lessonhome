
class Mail
  constructor : ->

  send : (template, email, subject, repls, images) ->

  #repls {key: value, ...}
  #images [filepath, filepath1, ...]

    nodemail = require 'nodemailer'
    fs = require 'fs'
    request = require 'request'

    transporter = nodemail.createTransport
      service : 'Gmail'
      auth :
        user : 'support@lessonhome.ru'
        pass : 'Jlth;bvjcnm'

    attachments = []

    for filepath in images
      do (filepath) ->
        attachments.push(
          {
            filename: filepath.replace(/(\/.+\/)*/, '')
            path: '../../../../www/lessonhome/static' + filepath

            cid: filepath.replace(/(\/.+\/)*/, '').replace(/\..+/, '') + '@lessonhome'
          }
        )

    mailOptions =
      from : 'Лессон Хоум ✔ <support@lessonhome.ru>'
      to   : email
      subject : subject
      attachments : attachments


    fs.readFile(template, (err, data) ->

      data = data.toString()

      for image in attachments
        do (image) ->
          data = data.replace(new RegExp('{{' + image.filename + '}}', 'g'), '\'cid:' + image.cid + '\'')

      request.post(
        {
          url:'http://premailer.dialect.ca/api/0.1/documents'
          form:{html: data}
        }
        (error, response, body) ->

          request(
            {
              url: JSON.parse(body).documents.html
            }
            (error, response, body) ->

              for key, value of repls
                do (key, value) ->
                  body = body.replace(new RegExp('#{' + key + '}', 'g'), value)

              mailOptions.html = body

              transporter.sendMail mailOptions,(err,info)->
                console.error err if err?
                console.log 'sent', info
          )
      )
    )

module.exports = Mail


mail = new Mail()

mail.send(
  '../../../../www/lessonhome/mails/example.html'
  'arsereb@gmail.com'
  'Добро пожаловать!'
  {
    name: 'Иван'
    surname: 'Иванов'
    login: 'Ivan'
  }
  ['/header/blue_logo.png', '/main/main_pattern.png', '/main/email_hello.png']
)
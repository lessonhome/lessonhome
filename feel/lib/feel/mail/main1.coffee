
class Mail
  constructor : ->
    Wrap @
  send : (template, email, subject, repls) ->

    d = Q.defer()

    nodemail = require 'nodemailer'
    fs = require 'fs'
    request = require 'request'

    transporter = nodemail.createTransport
      service : 'Gmail'
      auth :
        user : 'support@lessonhome.ru'
        pass : 'Jlth;bvjcnm'

    attachments = []

    mailOptions =
      from : 'Лессон Хоум ✔ <support@lessonhome.ru>'
      to   : email
      subject : subject
      attachments : attachments

    fs.readFile(template, (err, data) ->

      data = data.toString()

      for key, value of repls
        do (key, value) ->
          data = data.replace(new RegExp('#{' + key + '}', 'g'), value)

      images = {}

      for image in data.match(/{{.+}}/g)
        do (image) ->

          image = image.replace(/{|}/g, '')

          if !images.hasOwnProperty(image)
            images[image] = true

            attachments.push(
              {
                filename: image.replace(/(\/.+\/)*/, '')
                path: '../../../../www/lessonhome/static' + image
                cid: image.replace(/(\/.+\/)*/, '').replace(/\..+/, '') + '@lessonhome'
              }
            )

            data = data.replace(new RegExp('{{' + image + '}}', 'g'), '\'cid:' + image.replace(/(\/.+\/)*/, '').replace(/\..+/, '') + '@lessonhome\'')
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

              mailOptions.html = body

              transporter.sendMail mailOptions,(err,info)->
                return d.reject err if err?

                console.log 'sent', info
                d.resolve() unless err
          )
      )
    )
    return d.promise

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
)
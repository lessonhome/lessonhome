
class Mail
  constructor : ->
    Wrap @
    @templates = {}
    @attachments = {}
  init : ->

    fs = require 'fs'

    fs.readdir(
      process.cwd()+'/www/lessonhome/mails'
      (err, files) =>

        console.log err if err?

        @prepareCss file for file in files
    )

  genResetToken: ->

    bcrypt = require 'bcryptjs'

    return bcrypt.genSaltSync(10);

  prepareCss: (file) =>

    fs = require 'fs'
    request = require 'request'

    fs.readFile(
      process.cwd()+'/www/lessonhome/mails/'+file
      (err, data) =>

        console.log err if err?

        @attachments[file] = []
        images = {}

        data = data.toString()

        for image in data.match(/{{.+}}/g)
          do (image) =>

            image = image.replace(/{|}/g, '')

            if !images.hasOwnProperty(image)
              images[image] = true

              @attachments[file].push(
                {
                  filename: image.replace(/(\/.+\/)*/, '')
                  path: process.cwd()+'/www/lessonhome/static' + image
                  cid: image.replace(/(\/.+\/)*/, '').replace(/\..+/, '') + '@lessonhome'
                }
              )

              data = data.replace(new RegExp('{{' + image + '}}', 'g'), '\'cid:' + image.replace(/(\/.+\/)*/, '').replace(/\..+/, '') + '@lessonhome\'')

        request.post(
          {
            url:'http://premailer.dialect.ca/api/0.1/documents'
            form:{html: data}
          }
          (err, response, body) =>

            console.log err if err?

            return @prepareCss file if body[0] is '<'

            request(
              {
                url: JSON.parse(body).documents.html
              }
              (err, response, body) =>

                console.log err if err?

                @templates[file] = body

                console.log 'mail: '+file+' was read from mails to Mail.templates'
            )
        )
    )

  prepare: (data, repls)->

    for key, value of repls
      do (key, value) ->
        data = data.replace(new RegExp('#{' + key + '}', 'g'), value)

    return data

  send : (template, email, subject, repls) ->

    console.log 'mail: Sending mail to', email

    d = Q.defer()

    nodemail = require 'nodemailer'

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


    transporter.sendMail mailOptions,(err,info)->
      return d.reject err if err?

      console.log 'mail: Mail sent', info
      d.resolve() unless err

    return d.promise

module.exports = Mail
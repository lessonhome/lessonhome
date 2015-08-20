
class Mail
  constructor : ->
    Wrap @
    @templates = {}
    @attachments = {}
  init : =>
    fs = require 'fs'
    request = require 'request'

    _templates = @templates
    _attachments = @attachments

    fs.readdir(
      process.cwd()+'/www/lessonhome/mails'
      (err, files) ->

        inline = (file) ->

          console.log process.cwd()+'/www/lessonhome/mails/'+file

          fs.readFile(
            process.cwd()+'/www/lessonhome/mails/'+file
            (err, data) ->

              _attachments[file] = []
              images = {}

              data = data.toString()

              for image in data.match(/{{.+}}/g)
                do (image) ->

                  image = image.replace(/{|}/g, '')

                  if !images.hasOwnProperty(image)
                    images[image] = true

                    _attachments[file].push(
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
                (error, response, body) ->

                  return inline file if body[0] is '<'

                  request(
                    {
                      url: JSON.parse(body).documents.html
                    }
                    (error, response, body) ->

                      _templates[file] = body

                      console.log file+' was read from mails to Mail.templates'
                  )
              )
          )

        inline file for file in files
    )

  prepare: (data, repls)->

    for key, value of repls
      do (key, value) ->
        data = data.replace(new RegExp('#{' + key + '}', 'g'), value)

    return data

  send : (template, email, subject, repls) ->

    console.log 'Sending mail to', email

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

      console.log 'sent', info
      d.resolve() unless err

    return d.promise

module.exports = Mail
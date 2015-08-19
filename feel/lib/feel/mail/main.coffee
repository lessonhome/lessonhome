
class Mail
  constructor : ->
    Wrap @
  init : =>
  prepare: (data, repls)->

    attachments = []
    images = {}

    data = data.toString()

    for key, value of repls
      do (key, value) ->
        data = data.replace(new RegExp('#{' + key + '}', 'g'), value)

    for image in data.match(/{{.+}}/g)
      do (image) ->

        image = image.replace(/{|}/g, '')

        if !images.hasOwnProperty(image)
          images[image] = true

          attachments.push(
            {
              filename: image.replace(/(\/.+\/)*/, '')
              path: process.cwd()+'/www/lessonhome/static' + image
              cid: image.replace(/(\/.+\/)*/, '').replace(/\..+/, '') + '@lessonhome'
            }
          )

          data = data.replace(new RegExp('{{' + image + '}}', 'g'), '\'cid:' + image.replace(/(\/.+\/)*/, '').replace(/\..+/, '') + '@lessonhome\'')

    return {
      data: data
      attachments : attachments
    }

  sendMail : (template, email, subject, repls) ->

    console.log 'Sending mail to', email

    d = Q.defer()

    nodemail = require 'nodemailer'
    request = require 'request'

    mail = yield @prepare yield _readFile(process.cwd()+'/www/lessonhome/mails/' + template), repls

    transporter = nodemail.createTransport
      service : 'Gmail'
      auth :
        user : 'support@lessonhome.ru'
        pass : 'Jlth;bvjcnm'

    mailOptions =
      from : 'Лессон Хоум ✔ <support@lessonhome.ru>'
      to   : email
      subject : subject
      attachments : mail.attachments

    request.post(
      {
        url:'http://premailer.dialect.ca/api/0.1/documents'
        form:{html: mail.data}
      }
      (error, response, body) ->

        return d.reject 'Expected JSON, got HTML requesting Premailer API at Mail.sendMail' if body[0] is '<'

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

    return d.promise

  send: (template, email, subject, repls) ->

    d = Q.defer()

    _send =  @send

    @sendMail.apply(null, arguments).catch((err) ->
      console.log err
      console.log 'Trying to send mail one more time...'

      _send(template, email, subject, repls)
    )

    d.resolve()

module.exports = Mail
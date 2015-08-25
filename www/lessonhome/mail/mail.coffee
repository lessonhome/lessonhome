
nodemail = require 'nodemailer'
fs = require 'fs'

transporter = nodemail.createTransport
  service : 'Gmail'
  auth :
    user : 'support@lessonhome.ru'
    pass : 'Jlth;bvjcnm'

attachments = [
  {
    fileName : 'blue_logo.png'
    filePath : '../static/header/blue_logo.png'
    cid : 'blue_logo@lessonhome'
  },
  {
    fileName : 'main_pattern.png'
    filePath : '../static/main/main_pattern.png'
    cid : 'main_pattern@lessonhome'
  },
  {
    fileName : 'email_hello.png'
    filePath : '../static/header/email_hello.png'
    cid : 'email_hello@lessonhome'
  }
]
mailOptions =
  from : 'Лессон Хоум ✔ <support@lessonhome.ru>'
  to   : 'arsereb@gmail.com'
  subject : 'Тестовое письмо'
  html : fs.readFileSync('./main.html').toString()
  attachments : attachments
  generateTextFromHTML: true

transporter.sendMail mailOptions,(err,info)->
  console.error err if err?
  console.log 'sent', info





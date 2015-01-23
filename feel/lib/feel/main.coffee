
Services = require './services'

class Main
  init : =>
    Q().then =>
      @services = new Services
      @services.start 'compile'


module.exports = Main


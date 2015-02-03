
Services = require './services'

class Main
  constructor : ->
    Wrap @
  init : =>

    Q().then =>
      @services = new Services
      @services.start 'compile'


module.exports = Main




Telegram = require './telegram'

class Messager
  init : =>
    @telegram = new Telegram
    yield @telegram.init()

module.exports = Messager




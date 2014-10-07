
LoadSites = require './scripts/loadSites'


module.exports = ->
  Q()
  .then LoadSites

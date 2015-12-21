(function() {
  var Path;

  Path = (function() {
    function Path() {
      this.sites = 'www';
      this.root = process.cwd();
    }

    return Path;

  })();

  module.exports = Path;

}).call(this);

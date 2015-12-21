(function() {
  var ee;

  ee = new EE;

  ee.on('a', function() {});

  ee.once('a', function() {});

  ee.emit('a');

  module.exports = function(key) {
    switch (key) {
      case '__serviceName':
        return false;
    }
    if (ee[key] != null) {
      return true;
    }
    switch (key) {
      case 'init':
      case 'log':
      case 'error':
      case '_lock':
      case '_unlock':
      case '_block':
      case '_unblock':
      case '_single':
        return true;
    }
    if (key.match(/^__.*$/)) {
      return true;
    }
    return false;
  };

}).call(this);

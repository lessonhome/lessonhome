this._normalizePath = function (str, stripTrailing) {
  if (typeof str !== 'string') {
    throw new TypeError('expected a string');
  }
  str = str.replace(/[\\\/]+/g, '/');
  str = str.replace(/^\.\//, '');
  if (stripTrailing !== false) {
    str = str.replace(/\/$/, '');
  }
  return str;
};

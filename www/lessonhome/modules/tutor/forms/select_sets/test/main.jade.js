function template(locals) {
var jade_debug = [{ lineno: 1, filename: undefined }];
try {
var buf = [];
var jade_mixins = {};
var jade_interp;
;var locals_for_with = (locals || {});(function (default_options, undefined) {
jade_debug.unshift({ lineno: 0, filename: jade_debug[0].filename });
jade_debug.unshift({ lineno: 1, filename: jade_debug[0].filename });
var data = default_options
jade_debug.shift();
jade_debug.unshift({ lineno: 2, filename: jade_debug[0].filename });
buf.push("<div class=\"select-sets\">");
jade_debug.unshift({ lineno: undefined, filename: jade_debug[0].filename });
jade_debug.unshift({ lineno: 3, filename: jade_debug[0].filename });
buf.push("<input type=\"text\" autocomplete=\"off\" class=\"select-sets_input\"/>");
jade_debug.shift();
jade_debug.unshift({ lineno: 4, filename: jade_debug[0].filename });
buf.push("<select multiple=\"multiple\" class=\"select-sets__options\">");
jade_debug.unshift({ lineno: undefined, filename: jade_debug[0].filename });
jade_debug.unshift({ lineno: 5, filename: jade_debug[0].filename });
// iterate data
;(function(){
  var $$obj = data;
  if ('number' == typeof $$obj.length) {

    for (var $index = 0, $$l = $$obj.length; $index < $$l; $index++) {
      var elt = $$obj[$index];

jade_debug.unshift({ lineno: 5, filename: jade_debug[0].filename });
jade_debug.unshift({ lineno: 6, filename: jade_debug[0].filename });
buf.push("<option" + (jade.attr("value", elt.value, true, false)) + ">");
jade_debug.unshift({ lineno: undefined, filename: jade_debug[0].filename });
jade_debug.unshift({ lineno: 6, filename: jade_debug[0].filename });
buf.push("(default)" + (jade.escape((jade_interp = elt.text) == null ? '' : jade_interp)) + "");
jade_debug.shift();
jade_debug.shift();
buf.push("</option>");
jade_debug.shift();
jade_debug.shift();
    }

  } else {
    var $$l = 0;
    for (var $index in $$obj) {
      $$l++;      var elt = $$obj[$index];

jade_debug.unshift({ lineno: 5, filename: jade_debug[0].filename });
jade_debug.unshift({ lineno: 6, filename: jade_debug[0].filename });
buf.push("<option" + (jade.attr("value", elt.value, true, false)) + ">");
jade_debug.unshift({ lineno: undefined, filename: jade_debug[0].filename });
jade_debug.unshift({ lineno: 6, filename: jade_debug[0].filename });
buf.push("(default)" + (jade.escape((jade_interp = elt.text) == null ? '' : jade_interp)) + "");
jade_debug.shift();
jade_debug.shift();
buf.push("</option>");
jade_debug.shift();
jade_debug.shift();
    }

  }
}).call(this);

jade_debug.shift();
jade_debug.shift();
buf.push("</select>");
jade_debug.shift();
jade_debug.shift();
buf.push("</div>");
jade_debug.shift();
jade_debug.shift();}.call(this,"default_options" in locals_for_with?locals_for_with.default_options:typeof default_options!=="undefined"?default_options:undefined,"undefined" in locals_for_with?locals_for_with.undefined:typeof undefined!=="undefined"?undefined:undefined));;return buf.join("");
} catch (err) {
  jade.rethrow(err, jade_debug[0].filename, jade_debug[0].lineno, "- var data = default_options\n.select-sets\n  input.select-sets_input(type='text', autocomplete='off')\n  select.select-sets__options(multiple)\n    - each elt in data\n      option(value=elt.value) (default)#{elt.text}\n\n");
}
}
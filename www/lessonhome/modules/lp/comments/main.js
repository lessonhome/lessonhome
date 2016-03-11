function template(locals) {
var buf = [];
var jade_mixins = {};
var jade_interp;
;var locals_for_with = (locals || {});(function (main_rep, rew, undefined) {
jade_mixins["reviews"] = function(index, image, name, link, name_r, date_r, rating, subject, text){
var block = (this && this.block), attributes = (this && this.attributes) || {};
buf.push("<div class=\"col s12 m6 l3 comment-cell\"><div class=\"col s12 no-padding-col comment-img center-align\"><a" + (jade.attr("href", link, false, false)) + (jade.attr("data-i", index, false, false)) + " class=\"comment-img-link\"><img" + (jade.attr("src", image, true, false)) + " class=\"responsive-img\"/><div class=\"comment-tutor-name\"><div class=\"comment-img-layer\"><div class=\"comment-img-name\">" + (null == (jade_interp = name) ? "" : jade_interp) + "</div><div class=\"comment-img-subject\">" + (null == (jade_interp = subject) ? "" : jade_interp) + "</div></div></div></a></div><div class=\"col s12 no-padding-col comment-body\"><div class=\"col s12 comment-text\">" + (null == (jade_interp = text || 'Отзывов пока нет.') ? "" : jade_interp) + "</div><div class=\"col s12 right-align\"><div class=\"rew_name\">" + (null == (jade_interp = name_r) ? "" : jade_interp) + "</div><!--.rew_name!=date_r--></div></div></div>");
};
buf.push("<div class=\"container js-rew\"><div class=\"row no-margin-row title\"><div class=\"col s12\"><h2>Отзывы о преподавателях </h2></div><div class=\"col s10 cb-body js-slick_block clearfix offset-s1 slick-main\">");
// iterate main_rep
;(function(){
  var $$obj = main_rep;
  if ('number' == typeof $$obj.length) {

    for (var $index = 0, $$l = $$obj.length; $index < $$l; $index++) {
      var rep = $$obj[$index];

rew = rep.num_show_rev !== undefined ? rep.reviews[rep.num_show_rev] : {};
jade_mixins["reviews"](rep.index, rep.avatar, rep.name.first, rep.link, rew.name, rew.date, rew.mark, rew.subject ? rew.subject[0] : '', rew.review);
    }

  } else {
    var $$l = 0;
    for (var $index in $$obj) {
      $$l++;      var rep = $$obj[$index];

rew = rep.num_show_rev !== undefined ? rep.reviews[rep.num_show_rev] : {};
jade_mixins["reviews"](rep.index, rep.avatar, rep.name.first, rep.link, rew.name, rew.date, rew.mark, rew.subject ? rew.subject[0] : '', rew.review);
    }

  }
}).call(this);

buf.push("</div></div></div>");}.call(this,"main_rep" in locals_for_with?locals_for_with.main_rep:typeof main_rep!=="undefined"?main_rep:undefined,"rew" in locals_for_with?locals_for_with.rew:typeof rew!=="undefined"?rew:undefined,"undefined" in locals_for_with?locals_for_with.undefined:typeof undefined!=="undefined"?undefined:undefined));;return buf.join("");
}

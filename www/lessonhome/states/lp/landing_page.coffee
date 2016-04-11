class @main extends @template '../lp'
  route : '/ad/english'
  model   : 'tutor/bids/reports'
  title : "Lessonhome - репетиторы по английскому языку"
  tags   : [ 'tutor:reports']
  access : ['all']
  redirect : {
    tutor : 'tutor/profile'
  }
  tree : =>
    content : @module '$':
      _custom_body__yandex : '<script type="text/javascript"> (function (d, w, c) { (w[c] = w[c] || []).push(function() { try { w.yaCounter = w.yaCounter35797050 = new Ya.Metrika({ id:35797050, clickmap:true, trackLinks:true, accurateTrackBounce:true, webvisor:true, trackHash:true }); } catch(e) { } }); var n = d.getElementsByTagName("script")[0], s = d.createElement("script"), f = function () { n.parentNode.insertBefore(s, n); }; s.type = "text/javascript"; s.async = true; s.src = "https://mc.yandex.ru/metrika/watch.js"; if (w.opera == "[object Opera]") { d.addEventListener("DOMContentLoaded", f, false); } else { f(); } })(document, window, "yandex_metrika_callbacks"); </script> <noscript><div><img src="https://mc.yandex.ru/watch/35797050" style="position:absolute; left:-9999px;" alt="" /></div></noscript>'
      #'<!-- Yandex.Metrika counter --><script type="text/javascript"> (function (d, w, c) { (w[c] = w[c] || []).push(function() { try { w.yaCounter = w.yaCounter30199739 = new Ya.Metrika({ id:30199739, clickmap:true, trackLinks:true, accurateTrackBounce:true, webvisor:true, trackHash:true }); } catch(e) { } }); var n = d.getElementsByTagName("script")[0], s = d.createElement("script"), f = function () { n.parentNode.insertBefore(s, n); }; s.type = "text/javascript"; s.async = true; s.src = "/file/c23edbd496/metrika_watch.js"; if (w.opera == "[object Opera]") { d.addEventListener("DOMContentLoaded", f, false); } else { f(); } })(document, window, "yandex_metrika_callbacks");</script><noscript><div><img src="https://mc.yandex.ru/watch/30199739" style="position:absolute; left:-9999px;" alt="" /></div></noscript><!-- /Yandex.Metrika counter -->'
      id_page: 'landing_page'
      hide_head_button: true
      hide_menu_punkt: true
      value :
        phone : $urlform : pupil : 'phone'
        name : $urlform : pupil : 'name'
      short_attach : @module 'short_form/js_form' :
        value: $urlform : pupil : ''
      tutor_target: @state './target_tutor'
      comments: @state 'lp/comments':
        not_page_refresh: false

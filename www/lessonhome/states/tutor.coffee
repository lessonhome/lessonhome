class @main
  tree : => @module '$' :
    _custom_body__yandex : '<!-- Yandex.Metrika counter --><script type="text/javascript"> (function (d, w, c) { (w[c] = w[c] || []).push(function() { try { w.yaCounter = w.yaCounter30199739 = new Ya.Metrika({ id:30199739, clickmap:true, trackLinks:true, accurateTrackBounce:true, webvisor:true, trackHash:true }); } catch(e) { } }); var n = d.getElementsByTagName("script")[0], s = d.createElement("script"), f = function () { n.parentNode.insertBefore(s, n); }; s.type = "text/javascript"; s.async = true; s.src = "/file/c23edbd496/metrika_watch.js"; if (w.opera == "[object Opera]") { d.addEventListener("DOMContentLoaded", f, false); } else { f(); } })(document, window, "yandex_metrika_callbacks");</script><noscript><div><img src="https://mc.yandex.ru/watch/30199739" style="position:absolute; left:-9999px;" alt="" /></div></noscript><!-- /Yandex.Metrika counter -->'
    depend        : [
      @state 'libnm'
    ]
    bottom_block_attached : @module 'main/attached' :
      bottom_bar  : @state 'main/attached/bar'
      popup       : @state 'main/attached/popup'
    header        : @state 'tutor/header'  :
      icons       : @module '$/header/icons' :
        counter : '5'
      items     : @exports()
      line_menu : @exports()
    left_menu     : @state 'tutor/left_menu'
    sub_top_menu  : @exports()   # define if exists
    content       : @exports()   # must be defined
    footer        : @state 'footer'

  setTopMenu : (items)=>
    @tree.header.top_menu.items = items

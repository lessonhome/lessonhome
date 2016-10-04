
get = (pref="",arr=[],post="")->
  for a1 in arr
    for a2 in a1
      pref += a2
  pref += post
  return pref
toLen = (len=70,pref="",arr=[],post="",left=false)->
  while (m = get pref,arr,post).length > len
    ret = do ->
      unless arr.length
        unless post
          return true
        post = ""
        return
      if left
        arr[arr.length-1].pop()
        arr.pop() unless arr[arr.length-1].length
      else
        arr[0].pop()
        arr.shift() unless arr[0].length
      return
    break if ret
  return m



class @main
  route : '/lp'
  model : 'tutor/profile_registration/fourth_step'
  title : "LessonHome - Администрирование"
  access : ['all']
  redirect : {
  }
  forms : ['person']
  tree : =>
    metro = @const('metro')
    filter = @const('filter')
    @module '$' :
      _custom_body__yandex : '<!-- Yandex.Metrika counter --><script type="text/javascript"> (function (d, w, c) { (w[c] = w[c] || []).push(function() { try { w.yaCounter = w.yaCounter30199739 = new Ya.Metrika({ id:30199739, clickmap:true, trackLinks:true, accurateTrackBounce:true, webvisor:true, trackHash:true }); } catch(e) { } }); var n = d.getElementsByTagName("script")[0], s = d.createElement("script"), f = function () { n.parentNode.insertBefore(s, n); }; s.type = "text/javascript"; s.async = true; s.src = "/file/c23edbd496/metrika_watch.js"; if (w.opera == "[object Opera]") { d.addEventListener("DOMContentLoaded", f, false); } else { f(); } })(document, window, "yandex_metrika_callbacks");</script><noscript><div><img src="https://mc.yandex.ru/watch/30199739" style="position:absolute; left:-9999px;" alt="" /></div></noscript><!-- /Yandex.Metrika counter -->'
      ###
      _custom_body__jivo : "<!-- BEGIN JIVOSITE CODE {literal} -->
        <script type='text/javascript'>
          (function(){ var widget_id = 'RjeCfra2Z1';var d=document;var w=window;function l(){
            var s = document.createElement('script'); s.type = 'text/javascript'; s.async = true; s.src = '//code.jivosite.com/script/widget/'+widget_id; var ss = document.getElementsByTagName('script')[0]; ss.parentNode.insertBefore(s, ss);}if(d.readyState=='complete'){l();}else{if(w.attachEvent){w.attachEvent('onload',l);}else{w.addEventListener('load',l,false);}}})();</script>
            <!-- {/literal} END JIVOSITE CODE -->"
      ###
      lib : @state 'libm'
      opacity_header: @exports('content.opacity_header')
      bid_helper : @module "lp/bid"
      header  : @module "$/header":
        hide_head_button: @exports('content.hide_head_button')
        hide_menu_punkt: @exports('content.hide_menu_punkt')
        enter_button_show: @exports('content.enter_button_show')
        id_page: @exports('content.id_page')
        photo   : $form : person : 'avatar'
        src     : @F 'vk.unknown.man.jpg'
        first_name: $form : person : 'first_name'
        middle_name: $form : person : 'middle_name'
      content : @exports()
      footer  : @module "$/footer":
        id_page: @exports('content.id_page')
      bottom_block_attached : @module 'main/attached_panel' :
        bottom_bar  : @state 'main/attached_panel/bar'
        popup       : @state 'main/attached_panel/popup'
      profile         : @module 'profile':
        single_profile : @exports()
        value : $defer : =>
          index = _setKey @req.udata,'tutorProfile.index'
          jobs = _HelperJobs
          #t = (new Date()).getTime()
          #prep = yield jobs.solve 'getTutor',{index}
          #t -= (new Date()).getTime()
          #t2 = (new Date()).getTime()
          prep = yield jobs.solve 'getTutor',{index}
          #t2 -= (new Date()).getTime()
          #console.log {t,t2}
          pupil = _setKey @req.udata, 'pupil'
          prep["data_pupil"] = pupil
          if index
            link =  '/tutor?'+yield  Feel.udata.d2u 'tutorProfile',{index:prep.index}
            prep.name ?= {}
            prep.subjects ?= {}
            prep.about ?= ''
            name =  ""
            name += " "+prep.name.first if prep.name.first
            name += " "+prep.name.middle if prep.name.middle
            title1 = "Репетитор"
            title1 += " "+prep.name.first if prep.name.first
            title1 += " "+prep.name.middle if prep.name.middle
            ss = []
            for s in Object.keys(prep.subjects ? {})
              ss.push  _nameLib.get(s).fullName('dative')
            ss.sort (a,b)->a.length-b.length
            title2 = []
            title2.push " по "+ss[0] if ss[0]
            for i in [1...ss.length]
              title2.push ", "+ss[i] if ss[i]
            title3 = " - LessonHome"
            title = toLen 70,title1,[title2],title3
            @tree.profile._custom_title = title
            title1 = 'Предметы: '
            title2 = []
            ss =  Object.keys(prep.subjects ? {})
            ss.sort (a,b)->a.length-b.length
            title2.push " "+ss[0] if ss[0]
            for i in [1...ss.length]
              title2.push ", "+ss[i] if ss[i]
            desc = toLen 140,title1,[title2],""
            if (desc.length < 90) && prep.about
              desc += ". "+prep.about
              desc = desc.substr 0,137
              desc = desc.replace /\s+[\wа-яё]+$/gmi,''
              desc+= '...' if desc.match /[\wа-яё]$/gmi
            if prep.photos
              continue for own key, photo of prep.photos
              ava = photo
            else
              ava = {lurl:"",lwidth:0,lheight:0}
            @tree.profile._custom_description = desc
            tohead = "
<!-- Schema.org markup for Google+ -->
<meta itemprop='name' content='#{title}'>
<meta itemprop='description' content='#{desc}'>
<meta itemprop='image' content='https://lessonhome.ru#{ava.lurl}'>
<!-- Twitter Card data -->
<meta name='twitter:card' content='summary'>
<meta name='twitter:site' content='@LessonHome'>
<meta name='twitter:title' content='#{title}'>
<meta name='twitter:description' content='#{desc}'>
<meta name='twitter:image' content='https://lessonhome.ru#{ava.lurl}'>

<!-- Open Graph data -->
<meta property='og:title' content='#{title}'>
<meta property='og:type' content='article'>
<meta property='og:url' content='https://lessonhome.ru#{link}'>
<meta property='og:locale' content='ru_RU'>
<meta property='og:image' content='https://lessonhome.ru#{ava.lurl}'>
<meta property='og:image:width' content='#{ava.lwidth}'> 
<meta property='og:image:height' content='#{ava.lheight}'>
<meta property='og:description' content='#{desc}'>
<meta property='og:site_name' content='Lessonhome'>
            "
            @tree.profile._custom_head = tohead
          return prep
      single_profile  : @exports()
      req_call : @module 'lp/request_call'
      bid_popup : @module 'lp/bid_popup':
        select_sub : @state 'forms/materialize_subjects' :
          value : $urlform: tutorsFilter: 'subjects'
        select_metr : @state 'forms/materialize_metro' :
          value : $urlform: tutorsFilter: 'metro'
        value: {
          name: $urlform: pupil: 'name'
          phone: $urlform: pupil: 'phone'
#          comment: $urlform: pupil: 'prices'
#          gender: $urlform: pupil: 'gender'
#          prices: $urlform: pupil: 'comment'
        }
        subjects : filter.subjects
        prices: filter.price
        status: filter.obj_status
        metro: metro.for_select
        metro_lines: metro.lines

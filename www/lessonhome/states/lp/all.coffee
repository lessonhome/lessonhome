class @main  extends @template '../lp'
  route : '/lp_all'
  model   : 'tutor/bids/reports'
  title : "LessonHome - Администрирование"
  access : ['other']
  redirect : {

  }
  tree : =>
    content : @module '$':
      tutor : @module 'main/tutor_list/tutor':
        value : {"login":"sudosubl@gmail.com","index":93983,"registerTime":1447743767930,"accessTime":1449128524021,"rating":5.138136293258395,"check_out_the_areas":["Альпийская свежесть","Горный источник","кисло-сладнкий соус"],"ratio":1,"nophoto":true,"account":"0622b895708c7d22baac54d9fb311ef83b0cf40b","landing":false,"mcomment":"","filtration":false,"phone":["89199829034","Дополнинтельный телефон"],"email":["sudosubl@gmail.com"],"name":{"first":"Имя","last":"Фамилия","middle":"Отчествович"},"slogan":"Казнить всех палачей!!","interests":[{"description":"Интересы"}],"work":[{"place":"Место работы","post":"Должность"},{"place":"Место работы1","post":"Должность1"}],"about":"О се. Круто!","subjects":{"испанский язык":{"description":"Второй. Научу врать","tags":{"DELE A":1,"school:0":true,"school:1":false,"school:2":false,"school:3":true,"student":true,"adult":false,"испанский язык":true},"course":["DELE A"],"price":{"left":600,"right":2700},"duration":{"left":60,"right":120},"place_prices":{"tutor":{"v60":"1200"},"pupil":{"v60":"2222","v120":"2222"}},"price_per_hour":975},"канистра с бензином":{"description":"Привет, дистрофик","tags":{"подготовка к олимпиадам":1,"school:0":true,"school:1":false,"school:2":false,"school:3":true,"student":true,"adult":false,"канистра с бензином":true},"course":["подготовка к олимпиадам"],"price":{"left":600,"right":2700},"duration":{"left":60,"right":120},"place_prices":{"tutor":{"v60":"3333","v90":"1233"}},"price_per_hour":975},"Торт-мороженое":{"description":"","tags":{"school:0":true,"school:1":false,"school:2":true,"school:3":true,"student":true,"adult":false,"Торт-мороженое":true},"course":[],"price":{"left":600,"right":2700},"duration":{"left":60,"right":120},"place_prices":{"tutor":{"v60":"332","v90":"2222","v120":"3333"},"pupil":{"v60":"0","v90":"3434"},"remote":{"v60":"4000","v90":"5000","v120":"6500"}},"price_per_hour":975},"музыка":{"description":"","tags":{"school:0":false,"school:1":false,"school:2":false,"school:3":true,"student":true,"adult":false,"музыка":true},"course":[],"price":{"left":600,"right":2700},"duration":{"left":60,"right":120},"place_prices":{"pupil":{"v60":"1231","v90":"2333","v120":"3333"}},"price_per_hour":975},"Апельсинки":{"description":"У меня нет комментариев","tags":{"Суп":1,"Литиевые батарейки":1,"синхрофазотрон":1,"квантовая запутонность":1,"school:0":false,"school:1":false,"school:2":false,"school:3":true,"student":true,"adult":false,"Апельсинки":true},"course":["Суп","Литиевые батарейки","синхрофазотрон","квантовая запутонность"],"price":{"left":600,"right":2700},"duration":{"left":60,"right":120},"place_prices":{"tutor":{"v60":"111","v90":"1212","v120":"1313"},"pupil":{"v60":"1231","v90":"2333","v120":"3333"},"remote":{"v60":"6000","v90":"1","v120":"200"}},"price_per_hour":975}},"age":20,"education":[{"name":"ВолгГТУ","faculty":"Электроники и вычислительной техники","country":"Россия","city":"Волгоград","chair":"Физики и вычислительной техники","qualification":"Задрот","comment":"Люфтбалонс","period":{"start":"","end":"2015"}},{"name":"Название вуза","faculty":"Тутси","country":"Белоруссия","city":"","chair":"Физки","qualification":"Нострадамус","comment":"","period":{"start":"1938","end":"1950"}}],"gender":"male","place":{"tutor":true,"pupil":true,"remote":true},"reason":"Почему я репититор","left_price":100,"right_price":6000,"newl":600,"newr":1350,"ordered_subj":["испанский язык","канистра с бензином","Торт-мороженое","музыка","Апельсинки"],"price_left":600,"price_right":2700,"duration_left":60,"duration_right":120,"price_per_hour":1000,"experience":"3-4 года","status":"student","media":[{"lwidth":200,"lheight":111,"lurl":"/file/98704717be/user_data/images/552daf1c25l.jpg","hheight":400,"hwidth":720,"hurl":"/file/21009702a8/user_data/images/552daf1c25h.jpg"},{"lwidth":200,"lheight":125,"lurl":"/file/45d75fa4af/user_data/images/3901fe314fl.jpg","hheight":450,"hwidth":720,"hurl":"/file/b5d71a2e44/user_data/images/3901fe314fh.jpg"},{"lwidth":200,"lheight":183,"lurl":"/file/6a7c6327dc/user_data/images/be66e78e29l.jpg","hheight":659,"hwidth":720,"hurl":"/file/fdf864ab51/user_data/images/be66e78e29h.jpg"},{"lwidth":200,"lheight":74,"lurl":"/file/6cb7771e47/user_data/images/c9fc178703l.jpg","hheight":268,"hwidth":720,"hurl":"/file/a40c8926b3/user_data/images/c9fc178703h.jpg"},{"lwidth":200,"lheight":74,"lurl":"/file/6cb7771e47/user_data/images/97d547cf40l.jpg","hheight":268,"hwidth":720,"hurl":"/file/a40c8926b3/user_data/images/97d547cf40h.jpg"}],"photos":[{"lwidth":130,"lheight":163,"lurl":"/file/f1468c11ce/unknown.photo.gif","hheight":163,"hwidth":130,"hurl":"/file/f1468c11ce/unknown.photo.gif"}],"location":{"country":"Страна","city":"Город","area":"Район","street":"Улица","house":"Дом","building":"Строение","flat":"Квартира","metro":"Ближайшее метро"},"ratingMax":5952.7,"ratingNow":4203,"rmin":141,"rmax":5952.7,"sorts":{"subject":0.38},"words":["испанский ","канистра с бензином","Торт-мороженое","музыка","Апельсинки","Имя","Отчествович","Фамилия","языки","иностранный"],"awords":{"0":true,"1":true,"2":true,"3":true,"strana":true,"gorod":true,"rayon":true,"ulica":true,"dom":true,"stroenie":true,"kvartira":true,"blizhayshee":true,"metro":true,"interesy":true,"a":true,"l":true,"":true,"p":true,"i":true,"y":true,"s":true,"k":true,"ya":true,"v":true,"e":true,"zh":true,"t":true,"alpiyskaya":true,"svezhest":true,"g":true,"o":true,"r":true,"n":true,"ch":true,"gornyy":true,"istochnik":true,"-":true,"d":true,"u":true,"kislo-sladnkiy":true,"sous":true,"volggtu":true,"elektroniki":true,"vychislitelnoy":true,"tehniki":true,"rossiya":true,"volgograd":true,"fiziki":true,"zadrot":true,"lyuftbalons":true,"nazvanie":true,"vuza":true,"tutsi":true,"belorussiya":true,"fizki":true,"nostradamus":true,"mesto":true,"raboty":true,"dolzhnost":true,"raboty1":true,"dolzhnost1":true,"imya":true,"familiya":true,"otchestvovich":true,"9199829034":true,"sudosublgmail":true,"com":true,"pochemu":true,"repititor":true,"kaznit":true,"vseh":true,"palachey":true,"se":true,"kruto":true,"ispanskiy":true,"yazyk":true,"dele":true,"vtoroy":true,"nauchu":true,"vrat":true,"school":true,"student":true,"adult":true,"kanistra":true,"benzinom":true,"podgotovka":true,"olimpiadam":true,"privet":true,"distrofik":true,"tort-morozhenoe":true,"muzyka":true,"apelsinki":true,"sup":true,"menya":true,"net":true,"kommentariev":true,"litievye":true,"batareyki":true,"sinhrofazotron":true,"kvantovaya":true,"zaputonnost":true},"points":0,"points2":0,"pointsNeed":false,"subject_dist":0.31}
      top_form  : @module 'main/fastest_top'
      value :
        phone : $urlform : pupil : 'phone'
        name : $urlform : pupil : 'name'
      filter : @exports()
      photo_src : @exports()
      title : @exports()
      sub_title : @exports()
      text : @exports()
      title_suit_tutors : @exports()
      landing_img: @exports()
      title_position: @exports()
      button_color: @exports()
      bg_position : @exports()
      opacity_form: @exports()
      ###
      tutors : do Q.async =>
        #console.log @req.urlData.filterHash()
        yield console.log @req.udata
        m = []
        for i in [0...5]
          m.push @module 'main/tutor_list/tutor':
            name : 'Конон Екатерина Владимировна'
            description : 'Индивидуальное обучение на гитаре — акустической, классической и электрогитаре в Одинцово и Одинцовском районе. Игорь Хотинский — профессиональный гитарист, работавший с Игорем Ивановым в группе «Кинематограф», с Юрием Лозой, с Женей Белоусовым, с Александром Малининым и другими составами.'
            experience  : 'Преподаватель ВУЗа, опыт более 4 лет'
            subject : 'Ритульаные жертвоприношения, Окультизм, Латынь'
            location  : 'Москва м. Перово'
        return m
      ###



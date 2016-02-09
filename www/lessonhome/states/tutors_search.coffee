class @main extends @template 'lp'
  route : '/tutors_search'
  model : 'tutor/profile_registration/fourth_step'
  title : "Наши репетиторы"
  tags   : [ 'tutor:reports']
  access : ['other','pupil']
  redirect : {
    tutor : 'tutor/profile'
  }
  tree : =>
    content : @module '$':
      id_page: 'search_p'
      filter_tags: @module '$/filter_tags' :
        value :
          filter  : $urlform : tutorsFilter : ''
        sex:
          items: @const('filter').sex
      search_filter: @module '$/search_filter':
        value :
          filter  : $urlform : tutorsFilter : ''
#          default_filter  : $durlform : mainFilter : ''
        subject_list: @const('filter').subjects
          ###
          popular :
            group: 'Популярные предметы'
            items: ["английский язык","математика","русский язык","музыка","физика","химия","биология","история","литература","начальная школа","подготовка к школе"]
          languages :
            group: 'Иностранные языки'
            items: ["английский язык","немецкий язык","французский язык","испанский язык","арабский язык","венгерский язык","голландский язык","греческий язык","датский язык","иврит","итальянский язык","китайския язык","корейский язык","латынь","норвежский язык","польский язык","португальский язык","сербский язык","турецкий язык","финский язык","хинди","чешский язык","шведский язык","японский язык"]
          music :
            group: 'Музыка'
            items: ["музыка","вокал","гитара","скрипка","сольфеджио","флейта","фортепиано"]
          other :
            group: 'Другое'
            items: ["обществознание","информатика","программирование","логопеды","актёрское мастерство","алгебра","бухгалтерский учёт","высшая математика","география","геометрия","компьютерная графика","логика","макроэкономика","математический анализ","менеджмент","микроэкономика","оригами","правоведение","психология","рисование","риторика","статистика","теоретическая механика","теория вероятностей","философия","черчение","шахматы","эконометрика","экономика","электротехника"]
          ###
        training_direction:
          items: @const('filter').course
        price_select:
          items: @const('filter').price
        status_tutor:
          items: @const('filter').status
        sex_tutor:
          items: @const('filter').sex
        metro_lines: @const('metro').lines
      from : $urldata : tutorsFilter : 'offset'
      count : 10
      tutors : $defer : =>
        metro =  Feel.const('metro')
        filters = @req.udata.tutorsFilter
        olds = @req.udata.mainFilter
        mf = {}
        mf.page = 'filter'
        mf.subject = filters.subjects
        
        ss = {}
        mf.subject ?= []
        for s in mf.subject
          ss[s] = true
        if olds.subject[0]
          for s in olds.subject
              ss[s] = true
        mf.subject = Object.keys ss
        mf.course = filters.course ? []
        ss = []
        for c in mf.course
          ss[c] = true
        for c in (olds.course ? [])
          ss[c] = true
        for m in (filters.metro ? [])
          m = metro.stations?[m?.split?(':')?[1] ? ""]?.name
          ss[m] = true if m
        mf.course = Object.keys ss
        l = 500
        r = 6000
        if filters.price?["до 700 руб."]
          if filters.price?["от 700 руб. до 1500 руб."]
            unless filters.price?["от 1500 руб."] then    r = 1500
          else unless filters.price?["от 1500 руб."] then r = 700
        else
          if filters.price?["от 700 руб. до 1500 руб."]
            l = 700
            unless filters.price?["от 1500 руб."] then r = 1500
          else if filters.price?["от 1500 руб."]  then l = 1500
        mf.price =
          left : l
          right : r
        mf.tutor_status ={}
        mf.tutor_status.student=true if filters.status['Студент']
        mf.tutor_status.native_speaker=true if filters.status['Носитель языка']
        mf.tutor_status.university_teacher=true if filters.status['Преподаватель ВУЗа']
        mf.tutor_status.school_teacher=true if filters.status['Преподаватель школы']
        mf.tutor_status.private_teacher=true if filters.status['Частный преподаватель']
        switch filters.sex
          when 'Мужской'
            mf.gender = 'male'
          when 'Женский'
            mf.gender = 'female'
          else
            mf.gender = ''
        #mf.course.push (filters.metro ? [])...
        filter = yield Feel.udata.d2u {'mainFilter':mf}
        hash = yield Feel.udata.filterHash filter,'filter'
        filter = yield Feel.udata.u2d filter
        jobs = yield Main.service 'jobs'
        from = filters.offset ? 0
        o = yield jobs.solve 'filterTutors',{filter:{data:filter.mainFilter,hash},count:10,from:from}
        o ?= {}
        o.preps ?= {}
        modules = []
        filter_stations = []
        arr = _setKey @req.udata,'tutorsFilter.metro'
        for s in arr
          filter_stations.push {
            metro : metro.stations[s.split(':')[1]].name
            color : metro.lines[s.split(':')[0]].color
            key : s.split(':')[1]
          }
        prev = from-10
        next = from+10
        if prev < 0
          prev = 0
        iss = o?.filters?[hash]?.indexes ? []
        if next > (iss.length-1)
          next = false
        nf = {}
        for key,val of filters
          nf[key]=val
        if iss.length > 10
          if prev || next>10
            nf.offset = prev
            prev = '/tutors_search?'+yield Feel.udata.d2u 'tutorsFilter',nf
          if next
            nf.offset = next
            next = '/tutors_search?'+yield Feel.udata.d2u 'tutorsFilter',nf
          @tree.content.forward = {next,prev}

        for i in [from...from+10]
          break unless iss[i]
          index = iss[i]
          prep = o.preps[index]
          prep.filter_stations = filter_stations
          modules.push @module 'main/tutor_list/tutor': value:prep

        return modules

      tutor : @module 'main/tutor_list/tutor':
        value : {"login":"katalinapak@gmail.com","index":100964,"registerTime":1443710139418,"accessTime":1448468706883,"rating":5.148879190636778,"check_out_the_areas":["Университет, Киевская, Славянский бульвар, Спортивная, Парк Культуры, Тропарево, Ленинский проспект, Смоленская, Проспект Вернадского, Юго-Западная"],"ratio":1,"nophoto":false,"account":"469c970542daf5b511c87f23c96f99c0020e69e4","landing":false,"mcomment":"","filtration":false,"phone":["+7 (926) 721-97-37",""],"email":["katalinapak@gmail.com"],"name":{"first":"Екатерина","last":"Старшинина","middle":"Александровна"},"slogan":"Живи здесь и сейчас","interests":[{"description":"Работа с детьми, кулинария, здоровый образ жизни"}],"work":[{"place":"Репетиторство","post":"Частный репетитор"}],"about":"Большой опыт работы в разных сферах. Работала администратором загородного комплекса, в Банке, в магазине одежды, меняла часто работу, НО всегда занималась репетиторством! Добрая, отзывчивая, с пониманием отношусь к любым ситуациям.","subjects":{"английский язык":{"description":"","tags":{"с нуля":1,"ОГЭ(ГИА)":1,"Разговорный":1,"school:0":true,"school:1":true,"school:2":true,"school:3":false,"student":false,"adult":false,"английский язык":true},"course":["с нуля","ОГЭ(ГИА)","Разговорный"],"price":{"left":600,"right":2700},"duration":{"left":60,"right":120},"place_prices":{"pupil":{"v60":"800"},"remote":{"v60":"300"}},"price_per_hour":975},"математика":{"description":"","tags":{"школьный курс":1,"school:0":false,"school:1":true,"school:2":true,"school:3":false,"student":false,"adult":false,"математика":true},"course":["школьный курс"],"price":{"left":600,"right":2700},"duration":{"left":60,"right":120},"place_prices":{"pupil":{"v60":"800"},"remote":{"v60":"300"}},"price_per_hour":975},"начальная школа":{"description":"","tags":{"school:0":false,"school:1":true,"school:2":false,"school:3":false,"student":false,"adult":false,"начальная школа":true},"course":[],"price":{"left":600,"right":2700},"duration":{"left":60,"right":120},"place_prices":{"pupil":{"v60":"800"}},"price_per_hour":975},"обществознание":{"description":"","tags":{"ОГЭ(ГИА)":1,"школьный курс":1,"school:0":false,"school:1":false,"school:2":true,"school:3":true,"student":false,"adult":false,"обществознание":true},"course":["ОГЭ(ГИА)","школьный курс"],"price":{"left":600,"right":2700},"duration":{"left":60,"right":120},"place_prices":{"pupil":{"v60":"800"},"remote":{"v60":"300"}},"price_per_hour":975},"подготовка к школе":{"description":"","tags":{"school:0":true,"school:1":false,"school:2":false,"school:3":false,"student":false,"adult":false,"подготовка к школе":true},"course":[],"price":{"left":600,"right":2700},"duration":{"left":60,"right":120},"place_prices":{"pupil":{"v60":"800"}},"price_per_hour":975},"менеджмент":{"description":"","tags":{"школьный курс":1,"ОГЭ(ГИА)":1,"school:0":false,"school:1":false,"school:2":true,"school:3":true,"student":false,"adult":false,"менеджмент":true},"course":["школьный курс","ОГЭ(ГИА)"],"price":{"left":600,"right":2700},"duration":{"left":60,"right":120},"place_prices":{"pupil":{"v60":"800"},"remote":{"v60":"300"}},"price_per_hour":975}},"age":22,"education":[{"country":"Россия","city":"Москва","name":"МГУ им. Ломоносова","faculty":"Экономический","chair":"Менеджмент","qualification":"Бакалавр","period":{"start":"2011","end":"2015"}}],"gender":"female","place":{"pupil":true,"remote":true},"reason":"Я люблю помогать взрослым и детям. Именно поэтому я поступила в медицинский (2 образование) и занимаюсь частным репетиторством.","left_price":300,"right_price":800,"newl":600,"newr":1350,"price_left":600,"price_right":2700,"duration_left":60,"duration_right":120,"price_per_hour":1000,"experience":"более 4 лет","status":"private_teacher","photos":[{"lwidth":200,"lheight":300,"lurl":"/file/55a011a202/user_data/images/236d8d1f39l.jpg","hheight":1082,"hwidth":720,"hurl":"/file/e38cdd438f/user_data/images/236d8d1f39h.jpg"}],"location":{"country":"Россия","city":"Москва"},"ratingMax":7221,"ratingNow":5289,"rmin":141,"rmax":7221,"sorts":{},"words":["английский ","математика","начальная школа","обществознание","подготовка к школе","менеджмент","Екатерина","Александровна","Старшинина","языки","иностранный"],"awords":{"0":true,"1":true,"2":true,"3":true,"rossiya":true,"moskva":true,"rabota":true,"s":true,"detmi":true,"kulinariya":true,"zdorovyy":true,"obraz":true,"zhizni":true,"u":true,"n":true,"i":true,"v":true,"e":true,"r":true,"t":true,"k":true,"a":true,"ya":true,"l":true,"y":true,"b":true,"":true,"p":true,"o":true,"m":true,"d":true,"g":true,"yu":true,"-":true,"z":true,"universitet":true,"kievskaya":true,"slavyanskiy":true,"bulvar":true,"sportivnaya":true,"park":true,"kultury":true,"troparevo":true,"leninskiy":true,"prospekt":true,"smolenskaya":true,"vernadskogo":true,"yugo-zapadnaya":true,"mgu":true,"im":true,"lomonosova":true,"ekonomicheskiy":true,"menedzhment":true,"bakalavr":true,"repetitorstvo":true,"chastnyy":true,"repetitor":true,"ekaterina":true,"starshinina":true,"aleksandrovna":true,"9267219737":true,"katalinapakgmail":true,"com":true,"lyublyu":true,"pomogat":true,"vzroslym":true,"detyam":true,"imenno":true,"poetomu":true,"postupila":true,"medicinskiy":true,"obrazovanie":true,"zanimayus":true,"chastnym":true,"repetitorstvom":true,"zhivi":true,"zdes":true,"seychas":true,"bolshoy":true,"opyt":true,"raboty":true,"raznyh":true,"sferah":true,"rabotala":true,"administratorom":true,"zagorodnogo":true,"kompleksa":true,"banke":true,"magazine":true,"odezhdy":true,"menyala":true,"chasto":true,"rabotu":true,"no":true,"vsegda":true,"zanimalas":true,"dobraya":true,"otzyvchivaya":true,"ponimaniem":true,"otnoshus":true,"lyubym":true,"situaciyam":true,"angliyskiy":true,"yazyk":true,"nulya":true,"oge":true,"gia":true,"razgovornyy":true,"school":true,"student":true,"adult":true,"matematika":true,"shkolnyy":true,"kurs":true,"nachalnaya":true,"shkola":true,"obshchestvoznanie":true,"podgotovka":true,"shkole":true}}
        ###
        name : 'Конон Екатерина Владимировна'
        description : 'Индивидуальное обучение на гитаре — акустической, классической и электрогитаре в Одинцово и Одинцовском районе. Игорь Хотинский — профессиональный гитарист, работавший с Игорем Ивановым в группе «Кинематограф», с Юрием Лозой, с Женей Белоусовым, с Александром Малининым и другими составами.'
        experience  : 'Преподаватель ВУЗа, опыт более 4 лет'
        subject : 'Ритульаные жертвоприношения, Окультизм, Латынь'
        location  : 'Москва м. Перово'
        price : 500
        photo : 'https://lessonhome.ru/file/5453ab9948/user_data/images/323e35c6f4l.jpg'
        ###

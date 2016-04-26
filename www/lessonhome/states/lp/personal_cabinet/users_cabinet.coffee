class @main extends @template 'lp'
  route : '/users_cabinet'
  model : 'main_m'
  title : "Личный кабинет"
  tags   : [ 'tutor:reports']
  access : ['all']
  redirect : {
    tutor : 'tutor/profile'
  }
  tree : =>
    content : @module '$':
      depend : @module 'lib/socket.io'
      id_page: 'uc_page'
      personal_info: @state './personal_info' :
        pupil : $defer : =>
          jobs =  _Helper 'jobs/main'
          pupil = yield jobs.solve 'pupilGetPupil',@req.user.id
          return pupil
      bids : $defer : =>
        moderator =
          name : 'Мария'
          photo : '/file/2a7e8fc34b//lp/girl_operator.jpg'
        jobs =  _Helper 'jobs/main'
        bids = yield jobs.solve 'pupilGetBids',@req.user.id
        pupil = yield jobs.solve 'pupilGetPupil',@req.user.id
        ret = for bid,i in bids
          o = {pupil,moderator}
          o[key] = val for key,val of bid
          if i == 0
            o.active = true
          yield @state './bid' : o
        return ret



####
# Данные аккаунта юзера (логины, пароли, привязанные сессии,типовые группы, такие как tutor/pupil)
####


accounts:
  id            : "7c6c373363470d87d77a1307a2994109fd8e2b22"  # uniq user id
  registerTime  : ISODate("2015-03-31T16:10:47.590Z")         # registration time
  accessTime    : ISODate("2015-03-31T16:10:47.590Z")         # last access time
  "{TYPE}" : true                     # if user have type TYPE,then TYPE will be true
  type:
    "{TYPE}" : true                   # if user have type TYPE,then type.TYPE will be true
  sessions      : {
    "e6346e6448da09859f07dac135883631f2162ba5" : true # if user have session then [sessions.hash] 
                                                      # will be true there
                                                      # user can have a lot of sessions
  }
  registered  : true                                  # if user have type not eq. 'other', then true
  login       : 'sergey'                              # user login if registered
  hash        : '$2a$10$nvAcA/bRIQxUw1fyhdR.Ve2eBz.1tTn1frkC8L5' # password hash if registered

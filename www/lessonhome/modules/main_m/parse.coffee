filter = Feel.const('filter')
subjects = filter.subjects

getExist = (obj) ->
  result = {}
  if obj then for key, val of obj when obj.hasOwnProperty(key) then result[val] = true
  return result

@parse = (value) ->
  value.sub_link = {}

  for key, ss of subjects when subjects.hasOwnProperty(key)
    value.sub_link[key] = a = []
    for subject in ss
      a.push {
        text: subject[0].toUpperCase() + subject.slice(1)
        link: "/tutors_search?#{ yield Feel.udata.d2u 'tutorsFilter', {subjects: [subject]} }"
      }

  value.cou_exist = getExist value.course
  value.sub_exist = getExist value.subjects
  return value
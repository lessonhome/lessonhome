subjects = Feel.const('filter').subjects
metro = Feel.const('metro')
lines = metro.for_select


getExist = (obj) ->
  result = {}
  if obj then for own key, val of obj then result[val] = true
  return result

@parse = (value) ->
  value.sub_link = a = {}

  for own key, ss of subjects
    for subject in ss
      a[subject] = {
        text: subject[0].toUpperCase() + subject.slice(1)
        link: "/tutors_search?#{ yield Feel.udata.d2u 'tutorsFilter', {subjects: [subject]} }"
      }

  value.metro = lines

  value.cou_exist = getExist value.course
  value.sub_exist = getExist value.subjects
  return value
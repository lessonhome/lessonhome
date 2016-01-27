


@rect = [
  { value : 'Заявка' }
  { value : 'target.subject'}
  { value : 'target.name' }
  { value : 'target.createTime'}
]


@linked = {
  tutor : [
    {
      type : 'textarea'
      value : 'link.comment'
    }
  ]
}

@full = [
  {
    type : 'photo'
    photo : 'target.photo'
  }
  { value : 'target.name'}
]


@filter = [
  {
    type: 'input',
    value: 'text'
  }
]
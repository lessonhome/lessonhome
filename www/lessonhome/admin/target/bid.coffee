


@rect = [
  { value : 'Заявка' }
  { value : 'target.subject'}
  { value : 'target.name' }
  { value : 'target.createTime'}
]
@short = [

]


@linked = {
  tutor : [
    {
      type : 'textarea'
      value : 'link.comment'
    }
  ]
}
@name = ""

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


@job = 'getFakeBids'
@signal = 'fakeBidsChange'
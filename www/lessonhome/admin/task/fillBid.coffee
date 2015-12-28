


@short = [
  { value : 'task.date'  }
  { value : 'Позвонить уточнить заявку'  }
  { value : 'target.subject' }
  { value : 'target.name' }
  { value : 'target.phone' }
  { value : 'task.comment' }
  { value : 'task.status' }
  { value : 'task.createTime'  }
]


@full = [
  {
    type : 'text'
    value : 'task.createTime'
  }
  {
    type : 'textarea'
    value : 'task.comment'
  }
  {
    type : 'dropdown'
    value : 'task.status'
    items : Feel.const('task').status
  }
  {
    type : 'date'
    value : 'task.date'
  }
]




class Find

  get : (o) => {
    $and : [
      {moderate : true}
      {
        $or : [
          {
            $or : [
              {process : $exists : false}
              {process : 'wait'}
            ]
            $or : [
              {id : $exists : false}
              {id : ''}
              {"linked.#{o.index}" : true}
            ]
          }
          {id : o.index}
        ]
      }
    ]
  }


module.exports = Find



class @main
  constructor: ->
    $W @
    @fields = {}
    @values = {}


  addField : (field, name) =>
    name = field.attr('name') unless name?
    return false unless name?
    throw new Error('wrong field') unless field instanceof jQuery

    unless @fields[name]?
      @fields[name] = field
    else
      @fields[name] = @fields[name].add(field)

    field.keyup @_onKeyUp(name)
    field.blur @_getListenKeyUp

  _onKeyUp : (name) => return (e) =>
    @fields[name].not(':focus').val( @values[name] = $(e.currentTarget).val() )
    Q.spawn -> Feel.sendActionOnce('interacting_with_form', 1000*60*10)

  _getListenKeyUp : => Q.spawn => @_setUrl()

  _setUrl : => yield Feel.urlData.set 'pupil', @values

  _execute : (data) => fields.val(data[name]) for own name, fields of @fields when data[name]?

  send : (quiet = false) =>
    yield @_setUrl()
    data = yield Feel.urlData.get 'pupil'
    data.linked = yield Feel.urlData.get 'mainFilter','linked'
    data.place = yield Feel.urlData.get 'mainFilter','place_attach'
    errs = @js.check(data)

    if errs.length is 0
      {status, err, errs} = yield @$send('./save', data, quiet && 'quiet')

      if status is 'success'
        Feel.sendActionOnce 'bid_popup'
        url = yield Feel.urlData.getUrl true
        url = url?.replace?(/\/?\?.*$/, '')
        Feel.sendActionOnce 'bid_action', null, {name: 'fast', url}
        return []

      errs?=[]
      errs.push err if err

    return errs

  setValue : (data) => @_execute data
  getValue : => @values

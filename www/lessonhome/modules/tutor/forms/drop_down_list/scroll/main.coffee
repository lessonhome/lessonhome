class @main extends EE
  elements : {}
  params :     #default parameters
    'axis': 'y'
    'graduation': 5
    'scrollMinLen': 10
    'min': 0
    'autoHide': false
    'logging': false
    'findContainerMethod': 'prev'
    #'showTestContainer': true

  #config interaction with other system
  selectors :
    dragEndBox: 'body'
  founds :
    scroll: 'scroll'
    scrollBox: 'scroll_box'
    module: 'label'
    topArrow: 'top_arrow'
    bottomArrow: 'bottom_arrow'
  workData :
    drag: null

  pxToNum : (px)->
    +px.substr(0, px.length-2)

  reinit : (paramsData)=>
    @init(paramsData)

  init : (paramsData)=>
    #config interaction
    #required refactor - using with @
    params = @params
    selectors = @selectors
    founds = @founds

    getParamsData = =>
      if paramsData? then return paramsData
      if @tree?.paramsData?
        @tree.paramsData

    #end config interaction
    @dom.data 'class', @

    #required refactor (definition into init, into show)
    ###################################################
    logger = (str)->
      if params['logging']
        console.log '[scroll]:'
        console.log str

    #required refactor (definition into init, into show
    elements = =>
      @tree.class.elements

    workData = (prop, val)=>
      if val?
        @tree.class.workData[prop]
      else @tree.class.workData[prop] = val

    pxToNum = (px)=>
      @tree.class.pxToNum(px)
    ########################################

    collectElements = (elements, paramsData, findContainerMethod, $scrollDom)=>
      #maybe required refactoring
      elements.scroll = @found[founds.scroll]
      elements.dragEndBox = @found[founds.scrollBox] #$(selectors.dragEndBox)
      elements.scrollBox = @found[founds.scrollBox]
      elements.module = @found[founds.module]
      elements.topArrow = @found[founds.topArrow]
      elements.bottomArrow = @found[founds.bottomArrow]
      if paramsData?.container?
        elements.container = paramsData.container
      else if findContainerMethod?
        if findContainerMethod == 'prev'
          elements.container = $scrollDom.prev()

      if paramsData.content?
        elements.content = paramsData.content
      else if elements.container?
        elements.content = elements.container.children().first()

    #parameters
    collectParams = (params, paramsData)->
      for prop of params
        if paramsData[prop]?
          params[prop] = paramsData[prop]
    # Init data
    collectParams(params, getParamsData())
    collectElements(elements(), getParamsData(), params.findContainerMethod, @dom)

    $scroll = elements().scroll

    #required refactoring
    scrollBoxLen = elements().scrollBox.height()
    containerLen = elements().container.height()
    contentLen = elements().content.height()

    invertScale = containerLen / contentLen
    scrollLen = scrollBoxLen * invertScale
    scrollLen = +scrollLen.toFixed()
    scrollMinLen = params['scrollMinLen']
    if scrollLen < scrollMinLen
      scrollLen = scrollMinLen
    if scrollLen > scrollBoxLen
      scrollLen = scrollBoxLen
      if params['autoHide']
        elements().module.hide()

    $scroll.height scrollLen

    max = scrollBoxLen - scrollLen
    params['max'] = max

    logger params
    logger elements()



  show : =>
    #required refactor (definition into init, into show)
    ###################################################
    logger = (str)->
      if params['logging']
        console.log '[scroll]:'
        console.log str

    #required refactor (definition into init, into show
    elements = =>
      @tree.class.elements

    params = @tree.class.params
    selectors = @tree.class.selectors

    workData = (prop, val)=>
      if val?
        @tree.class.workData[prop] = val
      else @tree.class.workData[prop]

    pxToNum = (px)=>
      @tree.class.pxToNum(px)
    ########################################

    init = =>
      @tree.class.init()

    bindingHandlers = =>
      #utils
      positionByAxis = ($block, axis, pos)->
        if axis == 'x'
          leftOrTop = 'left'
        else if axis == 'y'
          leftOrTop = 'top'
        $block.css(leftOrTop, pos)

      getScrollValue = ->
        pxToNum(elements().scroll.css 'top')

      correctPos = (containerHeight, contentHeight, pos, max) ->
        hiddenLen = contentHeight - containerHeight
        factor = hiddenLen / max
        -(pos * factor)

      positionContent = ($scroll)->
        $content = elements().content
        axis = params['axis']
        pos = getScrollValue $scroll
        containerHeight = elements().container.height()
        contentHeight = elements().content.height()
        max = params['max']
        positionByAxis $content, axis, correctPos(containerHeight, contentHeight, pos, max)
        # End init

      getDist = (ptStart, ptEnd, vertOrHorz)->
        ptEnd[vertOrHorz] - ptStart[vertOrHorz]
      ###########################################3

      elements().scrollBox.on 'mousedown.scroll', (event)->
        lastDist = (pxToNum elements().scroll.css('top'))
        workData('drag',
          x: event.screenX
          y: event.screenY
          lastDist: lastDist
        )

      elements().dragEndBox.on 'mouseup.scroll', (event)->
        workData('drag', false)
        if params.axis == 'y'
          pos = 'top'
        else if params.axis == 'x'
          pos = 'left'

      elements().dragEndBox.on 'mousemove', ->
        $scroll = elements().scroll
        dragData = workData('drag')
        logger dragData
        if (typeof dragData) == 'object' && dragData != null
          logger 'dragData:'
          logger dragData
          ptEnd =
            x: event.screenX
            y: event.screenY
          axis = params.axis
          lastDist = dragData.lastDist
          dist = getDist dragData, ptEnd, axis
          $scroll.trigger 'position.scroll',
            dist: dist
            lastDist: lastDist

      #Custom event
      elements().scroll.on 'position.scroll', (event, data)->
        $scroll = $(this)
        if (typeof data) == 'number'
          lastDist = 0
          dist = getScrollValue($scroll)
        else
          lastDist = data.lastDist
          dist = data.dist

        if !lastDist? then lastDist = 0

        scrollHeight = $scroll.height()
        scrollStart = lastDist + dist
        scrollEnd = lastDist + dist + scrollHeight
        scrollBoxHeight = elements().scrollBox.height()
        if scrollStart < 0
          wasMin = true
          scrollStart = 0
        if scrollEnd > scrollBoxHeight
          scrollStart = scrollBoxHeight - scrollHeight
          wasMax = true
        scrollStartPred = pxToNum($scroll.css 'top')
        $scroll.css('top', scrollStart)
        positionContent($scroll)
        elements().module.trigger 'change.scroll',
          {axis:'y', valuePred:scrollStartPred, value:scrollStart, min:wasMin, max:wasMax}

      elements().scroll.on 'position.scroll_move', (event, data)->
        $scroll = $(this)
        val = getScrollValue($scroll)
        dist = val + data.distDelta
        $scroll.trigger 'position.scroll', {dist:dist}

      #elements().scroll.trigger 'position.scroll', {dist:40}
      #elements().scroll.trigger 'position.scroll_move', {distDelta:10}

      moveOneGrad = (isBack)->
        grad = params['graduation']
        if isBack then grad = -grad
        elements().scroll.trigger 'position.scroll_move', {distDelta:grad}

      elements().topArrow.on 'click', (event)->
        moveOneGrad(true)

      elements().bottomArrow.on 'click', (event)->
        moveOneGrad()

      elements().module.on 'change.scroll', (event, data)->
        logger 'change.scroll:'
        logger data
        logger {min:data.min,max:data.max}

    init()
    bindingHandlers()
    ####

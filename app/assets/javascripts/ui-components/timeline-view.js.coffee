{div, p, a, svg, text, canvas} = React.DOM
cx = React.addons.classSet

# Class handling the rendering of the content on the timeline view canvas
class CanvasTimelineView
  constructor: (canvasId, timelines=[]) ->
    @colors = ['#F75AA0', '#F4244C', '#FF7C5F', '#FFBA4B', '#B8E986', '#49C076', '#5ED8D5', '#44B9E6', '#5773BB', '#9C67B5']

    @canvasId = canvasId
    @timelines = timelines
    jqCanvas = $(canvasId)
    @canvas = jqCanvas[0] # Get native object out
    @context = @canvas.getContext('2d')
    @hammer = new Hammer(@canvas)

    # Resize the canvas
    @setup()
    @context.scale(2,2)

    # Constant point size for events / timelines
    @pointSize = 6



    # Panning/Navigation config
    @scrollSpeed = 1.5
    @zoom = @findZoomLevel() # 4000000
    @tempFocus = new Date()
    @focusX = @canvas.width / 2
    #@focus = @dateToX(@focusDate)
    @focusDate = @tempFocus

    # Register callbacks
    window.onresize = @redraw

    @hammer.on 'pan', (event) =>
      @onPan(event)
    @hammer.on 'panend', (event) =>
      @afterPan(event)

    $('.ui-bar').on 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', (e) =>
      @redraw()

    $('.ui-bar').children().on 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', (e) ->
      e.stopPropagation()

  setup: ->
    jqCanvas = $(@canvasId)
    @canvas.width = jqCanvas.width() * 2
    @canvas.height = jqCanvas.height() * 2
    @focusX = @canvas.width / 2

  redraw: =>
    # Recalcuate
    @setup()
    @zoom = @findZoomLevel()
    @draw()

  draw: ->
    @drawFocusLine()
    @drawAxis()

    for timeline, timelineIndex in @timelines
      @context.fillStyle = @colors[timelineIndex % 10]
      for event in timeline.events
        x = @dateToX(new Date(event.start_date)) - 5
        @context.fillRect(x, 80, 10, 10)

    # Max
    @context.fillStyle = "rgb(200,0,0)"
    @context.fillRect(@dateToX(@maxDate()) - 10, 100, 20, 20)

    # Min
    @context.fillStyle = "rgba(0, 0, 200, 0.5)"
    @context.fillRect(@dateToX(@minDate()) - 10, 100, 20, 20)

    if @timelines.length > 0
      if @timelines[0].events.length > 0
        # @drawEvent(@timelines[0].events[0], @dateToX(new Date(@timelines[0].events[0].start_date)), 200, @colors[0], true, false)
        @drawEventWithRange(@timelines[0].events[1], 200, @colors[0], true, false)


  drawFocusLine: ->
    @context.font = '20pt "MB Empire"'
    @context.fillText(@liveXToDate(@focusX), @focusX, 600)
    @context.beginPath()
    @context.moveTo(@focusX, 40)
    @context.lineTo(@focusX, @canvas.height)
    @context.strokeStyle = "#d8d8d8"
    @context.stroke()

  drawAxis: ->
    max = @maxDate()
    year = max.getUTCFullYear()
    @drawTick(@dateToX(new Date(year, 0)), "2014")
    @drawTick(@dateToX(new Date(year - 1, 0)))
    @drawTick(@dateToX(new Date(year + 1, 0)))
    #console.log max, year

  drawTick: (x, label = null) ->
    if label
      @context.font = '20pt "MB Empire"'
      @context.fillText(@liveXToDate(x), @focusX, 600)
    @context.beginPath()
    @context.moveTo(x, 45)
    if label
      @context.lineTo(x, 70)
    else
      @context.lineTo(x, 60)
    @context.lineWidth = 2
    @context.strokeStyle = "rgba(0, 0, 0, 256)"
    @context.stroke()

  # Find the appropriate X coordinate for a given date
  dateToX: (date) ->
    (date - @focusDate) / @zoom + @focusX

  # Find the appropriate Date for a given X coordinate
  xToDate: (x) ->
    delta = (x - @focusX) * @zoom
    new Date(delta + @tempFocus.getTime())

  # Same as @xToDate(), but better. Avoid if you are likely to change @focusDate
  liveXToDate: (x) ->
    delta = (x - @focusX) * @zoom
    new Date(delta + @focusDate.getTime())

  findZoomLevel: ->
    if @timelines.length > 0
      x = @canvas.width * 0.9
      date = @maxDate().getTime() - @minDate().getTime()
      result = date // x
    else
      4000000

  # Returns the earliest date across the timelines
  minDate: ->
    events = @timelines[0].events
    min = new Date(@timelines[0].events[events.length - 1].start_date)
    for timeline in @timelines
      events = timeline.events
      date = new Date(timeline.events[events.length - 1].start_date)
      min = date if date < min
    min

  # Returns the latest date across the timelines
  maxDate: ->
    max = new Date(@timelines[0].events[0].end_date || @timelines[0].events[0].start_date)
    for timeline in @timelines
      date = new Date(timeline.events[0].end_date)
      max = date if date > max
    max

  # Calculates the halway point between the min and max dates
  midRange: ->
    min = @minDate()
    max = @maxDate()
    new Date(min.getTime() + ((max - min) / 2))

  # Consumes a event object and x coordinate and draws the
  # event to screen. Returns the calculated coordinates of
  # the touch area for click calcuation
  drawEvent: (event, x, y, color='#bbbbbb', showText=false, active=false) ->
    @context.fillStyle = color

    # Draw circle point at x,y
    @context.beginPath()
    @context.arc(x, y, @pointSize, 0, 2 * Math.PI)
    @context.fill()

    @context.strokeStyle = color
    @context.lineWidth = 4

    # Start just below drawn point
    if showText
      cPoint = {x: x, y: y + @pointSize}
      pad = 10 # Padding around text outline

      # Text Width and Height
      tW = @context.measureText(event.content).width
      tH = 22 # Approximation to 20pt font size

      # Draw Shape!
      @context.beginPath()
      @context.moveTo(cPoint.x, cPoint.y)

      point1  = {x: cPoint.x, y: cPoint.y + tH + 2*pad }
      cPoint2 = {x: point1.x, y: point1.y + pad }
      point2  = {x: cPoint2.x + pad, y: cPoint2.y }
      point3  = {x: point2.x + tW, y: point2.y }
      cPoint4 = {x: point3.x + pad, y: point2.y }
      point4  = {x: cPoint4.x, y: point1.y}
      point5  = {x: cPoint4.x, y: cPoint.y + 2*pad }
      cPoint6 = {x: point5.x, y: cPoint.y + pad }
      point6  = {x: point3.x, y: cPoint6.y }
      point7  = {x: cPoint.x + pad, y: point6.y }

      textPoint = { x: point2.x, y: point1.y }

      @context.lineTo(point1.x, point1.y)
      @context.quadraticCurveTo(cPoint2.x, cPoint2.y, point2.x, point2.y)
      @context.lineTo(point3.x, point3.y)
      @context.quadraticCurveTo(cPoint4.x, cPoint4.y, point4.x, point4.y)
      @context.lineTo(point5.x, point5.y)
      @context.quadraticCurveTo(cPoint6.x, cPoint6.y, point6.x, point6.y)
      @context.lineTo(point7.x, point7.y)
      @context.lineTo(cPoint.x, cPoint.y)

      @context.closePath()

      @context.stroke()

      # Draw fill and text based on active state
      if active then @context.fillStyle = color else @context.fillStyle = '#ffffff'
      @context.fill()

      if active then @context.fillStyle = '#ffffff' else @context.fillStyle = color
      @context.fillText(event.content, textPoint.x, textPoint.y)

      # Return the bounds of the drawn object
      { minX: x - @pointSize , minY: y - @pointSize, maxX: cPoint4.x, maxY: cPoint4.y }

  drawEventWithRange: (event, y, color='#bbbbbb', showText=false, active=false) ->
    startPointX = @dateToX(new Date(event.start_date))
    endPointX = @dateToX(new Date(event.end_date))

    @context.fillStyle = color
    @context.strokeStyle = color
    @context.lineWidth = 2;

    # Draw Range
    @context.beginPath()
    @context.arc(startPointX, y, @pointSize, 0, 2 * Math.PI)
    @context.fill();

    @context.beginPath()
    @context.arc(endPointX, y, @pointSize, 0, 2 * Math.PI)
    @context.fill();

    @context.beginPath()
    @context.moveTo(startPointX, y)
    @context.lineTo(endPointX, y)
    @context.stroke()

    # Start just below drawn point
    if showText
      tW = @context.measureText(event.content).width
      tH = 22 # Approximation to 20pt font size
      pad = 10; # Padding around text outline

      cPoint =  { x: (startPointX + endPointX) / 2, y: y + @pointSize }
      textMin = { x: cPoint.x - (tW / 2), y: cPoint.y + 2*pad }
      textMax = { x: cPoint.x + (tW / 2),  y: cPoint.y + tH + 2*pad }
      padMin  = { x: textMin.x - pad, y: textMin.y - pad }
      padMax  = { x: textMax.x + pad, y: textMax.y + pad }

      # Draw Shape!
      @context.beginPath()
      @context.moveTo(cPoint.x, cPoint.y)

      @context.lineTo(cPoint.x - pad, padMin.y)
      @context.lineTo(textMin.x, padMin.y)
      @context.quadraticCurveTo(padMin.x, padMin.y, padMin.x, textMin.y)
      @context.lineTo(padMin.x, textMax.y)
      @context.quadraticCurveTo(padMin.x, padMax.y, textMin.x, padMax.y)
      @context.lineTo(textMax.x, padMax.y)
      @context.quadraticCurveTo(padMax.x, padMax.y, padMax.x, textMax.y)
      @context.lineTo(padMax.x, textMin.y)
      @context.quadraticCurveTo(padMax.x, padMin.y, textMax.x, padMin.y)
      @context.lineTo(cPoint.x + pad, padMin.y)

      @context.closePath()
      @context.lineWidth = 4
      @context.stroke()

      # Draw fill and text based on active state
      if active then @context.fillStyle = color else @context.fillStyle = '#ffffff'
      @context.fill()

      if active then @context.fillStyle = '#ffffff' else @context.fillStyle = color;
      @context.fillText(event.content, textMin.x, textMax.y)



  updateTimelines: (timelines) ->
    @timelines = timelines
    @focusDate = @midRange()
    @tempFocus = @focusDate
    @zoom = @findZoomLevel()
    @redraw()

  onPan: (event) ->
    newDate = @xToDate(@focusX - event.deltaX * @scrollSpeed)
    if newDate > @minDate()
      if newDate < @maxDate()
        @focusDate = newDate
      else
        @focusDate = @maxDate()
    else
      @focusDate = @minDate()
    @redraw()

  afterPan: (event) ->
    newDate = @xToDate(@focusX - event.deltaX * @scrollSpeed)
    if newDate > @minDate()
      if newDate < @maxDate()
        @tempFocus = newDate
      else
        @tempFocus = @maxDate()
    else
      @tempFocus = @minDate()
    @focusDate = @tempFocus


# Local/Global object for hanging on to
# Snap state, etc
snapTimelineView = null # new snapTimelineView()
canvasTimelineView = null


TimelineView = React.createClass
  displayName: 'TimelineView'

  componentDidMount: ->
    # Bind snap.svg stuff here
    # @getDOMNode().innerHTML = ''
    # snapTimelineView = new SnapTimelineView('timeline-view')
    # $('').load =>

    canvasTimelineView = new CanvasTimelineView('#timeline-view')
    canvasTimelineView.updateTimelines(@props.timelines)

    @forceUpdate()

  componentWillUnmount: ->
    # Clean up SVG snap, binding, etc here
    snapTimelineView = null

  #componentWillReceiveProps: (nextProps) ->
    # If state needs to change on prop change,
    # do it here

  componentDidUpdate: (prevProps, prevState) ->
    # Manually do things with Snap here, and
    # draw new timelines, etc

    # Check if timelines changed?
    # if prevProps.timelines.length != @props.timelines.length
    # console.log @props.timelines
    # snapTimelineView.redraw(@props.timelines)
    canvasTimelineView.updateTimelines(@props.timelines)

  #getInitialState: ->
    # Grab the saved paper matrix, if any

  textNodes: ->
    if @props.timelines.length > 0
      @props.timelines[0].events.map (event) ->
        text {x: 200, y: 200, key: event.content + event.id},
          event.content

  render: ->

    classes = {
      'timeline-view': true
    }
    classes[@props.expandedPanel] = true

    canvas className: cx(classes), id: 'timeline-view',
      ''
      # @textNodes()


@.EpochUI ?= {}
@.EpochUI.TimelineView = TimelineView

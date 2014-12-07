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

    i = 0
    for timeline in @timelines
      @context.fillStyle = @colors[i % 10]
      for event in timeline.events
        x = @dateToX(new Date(event.start_date)) - 5
        @context.fillRect(x, 80, 10, 10)
      i++

    # Max
    @context.fillStyle = "rgb(200,0,0)"
    @context.fillRect(@dateToX(@maxDate()) - 10, 100, 20, 20)

    # Min
    @context.fillStyle = "rgba(0, 0, 200, 0.5)"
    @context.fillRect(@dateToX(@minDate()) - 10, 100, 20, 20)

    if @timelines.length > 0
      if @timelines[0].events.length > 0
        @drawEvent(@timelines[0].events[0], 50, 50, @colors[0], true, false)



  drawFocusLine: ->
    @context.font = '20pt "MB Empire"'
    @context.fillText(@liveXToDate(@focusX), @focusX, 600)
    @context.beginPath()
    @context.moveTo(@focusX, 40)
    @context.lineTo(@focusX, @canvas.height)
    @context.strokeStyle = "#d8d8d8"
    @context.stroke()


  # Find the appropriate X coordinate for a given date
  dateToX: (date) ->
    (date - @focusDate) / @zoom + @focusX

  # Find the appropriate Date for a given X coordinate
  xToDate: (x) ->
    delta = (x - @focusX) * @zoom
    new Date(delta + @tempFocus.getTime())

  liveXToDate: (x) ->
    delta = (x - @focusX) * @zoom
    new Date(delta + @focusDate.getTime())

  findZoomLevel: ->
    if @timelines.length > 0
      x = @canvas.width * 0.9
      console.log @canvas.width, x
      date = @maxDate()
      result = date.getTime() / x
      console.log result
      result / 25
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
    max = new Date(@timelines[0].events[0].end_date)
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
  drawEvent: (event, x, y, color='#bbbbbb', active=false) ->
    console.log 'Drawing Event!'

    @context.fillStyle = color;

    # Draw circle point at x,y
    @context.beginPath()
    @context.arc(x, y, @pointSize, 0, 2 * Math.PI)
    @context.fill();


    @context.fillStyle = '#ffffff';
    @context.strokeStyle = color;

    # event.content
    @context.moveTo(x, y + @pointSize)
    @context.beginPath()


    console.log 'Measuring Text Width',  @context.measureText('Text').width
    # console.log 'Measuring Text Height',  @context.measureText('Text').height


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

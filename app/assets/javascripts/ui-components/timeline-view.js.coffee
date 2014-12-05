{div, p, a, svg, text, canvas} = React.DOM
cx = React.addons.classSet

class SnapTimelineView
  constructor: (svgId)->
    # TODO Wipe existing svg here?
    @snap = Snap("##{svgId}")

    # console.log(timelines)
    @hammer = new Hammer(document.getElementById(svgId))
    @hammer.get('pinch').set(enable: true)
    @circle = @snap.circle(250, 100, 50)


    # events = []

    # for timeline in timelines
    #   for event in timeline.events
    #     @snap.text(200, start, event.content)
    #     start += 20

    # @text = @snap.text()
  #   @text = @snap.text(200, 200, 'React, Hammer, and Snap.svg playing nice together')
  #   @snap.zpd(pan: false, zoom: false)
  #
  #   @hammer.on 'tap', (event) =>
  #     @circle.attr
  #       fill: @circleColor()
  #       stroke: '#000',
  #       strokeWidth: 5
  #
  #   @hammer.on 'pinchmove', (event) =>
  #     @snap.zoomTo(event.scale, 5)
  #
  #   @hammer.on 'pan', (event) =>
  #     @snap.panTo event.center.x, event.center.y, 0
  #
  #
  redraw: (timelines) ->
    start = 200
    for timeline in timelines
      for event in timeline.events
        # @snap.text(200, start, event.content)
        @snap.circle(start, start, 10)
        start += 10
    # @circle.attr
    #   fill: '#bada55',
    #   stroke: '#000',
    #   strokeWidth: 5
  #
  # circleColor: ->
  #   Snap.rgb(@getRandomInt(255), @getRandomInt(255), @getRandomInt(255))
  #
  # getRandomInt: (max) ->
  #   Math.floor(Math.random() * max)


  # TODO Set all default zoom / pan stuff to false
  # Bind all zoom pan stuff to hammer.js events

  # Click events here get sent back to the react class




class CanvasTimelineView
  constructor: (canvasId, timelines=[]) ->
    colors: ['#F75AA0', '#F4244C', '#FF7C5F', '#FFBA4B', '#B8E986', '#49C076', '#5ED8D5', '#44B9E6', '#5773BB', '#9C67B5']

    @canvasId = canvasId
    @timelines = timelines
    console.log @timelines
    jqCanvas = $(canvasId)
    @canvas = jqCanvas[0] # Get native object out
    @hammer = new Hammer(@canvas)
    @canvas.width = jqCanvas.width() * 2
    @canvas.height = jqCanvas.height() * 2
    @context = @canvas.getContext('2d')
    @context.scale(2,2)

    @scrollSpeed = 1.5
    @focus = @canvas.width / 2
    @tempFocus = @focus
    window.onresize = @redraw

    @hammer.on 'pan', (event) =>
      @onPan(event)
    @hammer.on 'panend', (event) =>
      @afterPan(event)

    # TODO redraw during animation
    $('.ui-bar').on 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', (e) =>
      # Mysteriously getting called 5 times
      @redraw()

    $('.ui-bar').children().on 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend', (e) ->
      e.stopPropagation()

  redraw: =>
    # Recalcuate
    jqCanvas = $(@canvasId)
    @canvas.width = jqCanvas.width() * 2
    @canvas.height = jqCanvas.height() * 2

    #console.log @timelines
    
    #i = 20
    #for event in @timelines[0].events
      #@context.fillText(event.content, @focus, i)
      #i += 20
    @context.font = '30pt "MB Empire"'
    @context.fillText(@minDate(), @focus, 100)
    @context.fillText(@maxDate(), @focus, 200)
    # Test drawing
    @context.fillStyle = "rgb(200,0,0)"
    @context.fillRect(@focus, 10, 55, 50)

    @context.fillStyle = "rgba(0, 0, 200, 0.5)"
    @context.fillRect(@focus + 30, 30, 55, 50)

  minDate: ->
    events = @timelines[0].events
    min = @timelines[0].events[events.length - 1].start_date
    for timeline in @timelines
      events = timeline.events
      min = timeline.events[events.length - 1].start_date if timeline.events[events.length - 1].start_date < min
    min
   
  maxDate: ->
    max = @timelines[0].events[0].end_date
    for timeline in @timelines
      max = timeline.events[0].end_date if timeline.events[0].end_date > max
    max

  updateTimelines: (timelines) ->
    @timelines = timelines
    #console.log @timelines
    @redraw()

  onPan: (event) ->
    @focus = @tempFocus + (event.deltaX * @scrollSpeed)
    @redraw()

  afterPan: (event) ->
    @tempFocus += event.deltaX
    @focus = @tempFocus


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

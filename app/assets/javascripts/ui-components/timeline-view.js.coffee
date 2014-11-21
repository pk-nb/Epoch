{div, p, a, svg, text, canvas} = React.DOM

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
  constructor: (canvasId) ->
    @canvasId = canvasId
    jqCanvas = $(canvasId)
    @canvas = jqCanvas[0] # Get native object out
    @canvas.width = jqCanvas.width() * 2
    @canvas.height = jqCanvas.height() * 2
    @context = @canvas.getContext('2d')
    @context.scale(2,2)


  redraw: ->
    jqCanvas = $(@canvasId)
    @canvas.width = jqCanvas.width() * 2
    @canvas.height = jqCanvas.height() * 2

    @context.fillStyle = "rgb(200,0,0)"
    @context.fillRect(10, 10, 55, 50)

    @context.fillStyle = "rgba(0, 0, 200, 0.5)"
    @context.fillRect(30, 30, 55, 50)




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
    console.log @props.timelines
    # snapTimelineView.redraw(@props.timelines)
    canvasTimelineView.redraw()

  #getInitialState: ->
    # Grab the saved paper matrix, if any

  textNodes: ->
    if @props.timelines.length > 0
      @props.timelines[0].events.map (event) ->
        text {x: 200, y: 200, key: event.content + event.id},
          event.content

  render: ->
    canvas className: 'timeline-view', id: 'timeline-view',
      ''
      # @textNodes()


@.EpochUI ?= {}
@.EpochUI.TimelineView = TimelineView

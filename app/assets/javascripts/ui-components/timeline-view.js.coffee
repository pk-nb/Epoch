{div, p, a, svg} = React.DOM

class SnapTimelineView
  constructor: (svgId)->
    # TODO Wipe existing svg here?
    @snap = Snap("##{svgId}")

    @hammer = new Hammer(document.getElementById(svgId))
    @hammer.get('pinch').set(enable: true)
    @circle = @snap.circle(250, 100, 50)
    @text = @snap.text(200, 200, 'React, Hammer, and Snap.svg playing nice together')
    @snap.zpd(pan: false, zoom: false)

    @hammer.on 'tap', (event) =>
      @circle.attr
        fill: @circleColor()
        stroke: '#000',
        strokeWidth: 5

    @hammer.on 'pinchmove', (event) =>
      @snap.zoomTo(event.scale, 5)

    @hammer.on 'pan', (event) =>
      @snap.panTo event.center.x, event.center.y, 0


  redraw: (props=null, state=null) ->
    @circle.attr
      fill: '#bada55',
      stroke: '#000',
      strokeWidth: 5

  circleColor: ->
    Snap.rgb(@getRandomInt(255), @getRandomInt(255), @getRandomInt(255))

  getRandomInt: (max) ->
    Math.floor(Math.random() * max)


  # TODO Set all default zoom / pan stuff to false
  # Bind all zoom pan stuff to hammer.js events

  # Click events here get sent back to the react class



# Local/Global object for hanging on to
# Snap state, etc
snapTimelineView = null # new snapTimelineView()


TimelineView = React.createClass
  displayName: 'TimelineView'

  componentDidMount: ->
    # Bind snap.svg stuff here
    snapTimelineView = new SnapTimelineView('timeline-view')
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
    snapTimelineView.redraw()

  #getInitialState: ->
    # Grab the saved paper matrix, if any

  render: ->
    svg className: 'timeline-view', id: 'timeline-view',
      ''


@.EpochUI ?= {}
@.EpochUI.TimelineView = TimelineView

{div, p, a, svg} = React.DOM

class SnapTimelineView
  constructor: (svgId)->
    # TODO Wipe existing svg here?
    @snap = Snap(svgId)
    @circle = @snap.circle(250, 100, 50)
    @snap.zpd()



  redraw: (props=null, state=null)->
    @circle.attr
      fill: '#bada55',
      stroke: '#000',
      strokeWidth: 5



# Local/Global object for hanging on to
# Snap state, etc
snapTimelineView = null # new snapTimelineView()


TimelineView = React.createClass
  displayName: 'TimelineView'

  componentDidMount: ->
    # Bind snap.svg stuff here
    snapTimelineView = new SnapTimelineView('#timeline-view')
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

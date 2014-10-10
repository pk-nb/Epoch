{div} = React.DOM

TimelineView = React.createClass
  displayName: 'TimelineView'

  render: ->
    div className: 'timeline-view'

@.EpochUI ?= {}
@.EpochUI.TimelineView = TimelineView

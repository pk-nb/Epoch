{div, p} = React.DOM

TimelineView = React.createClass
  displayName: 'TimelineView'

  render: ->
    div className: 'timeline-view',
      p null,
        'Hello'


@.EpochUI ?= {}
@.EpochUI.TimelineView = TimelineView

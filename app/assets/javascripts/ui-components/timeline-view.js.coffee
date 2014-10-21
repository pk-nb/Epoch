{div, p} = React.DOM

TimelineView = React.createClass
  displayName: 'TimelineView'

  render: ->
    div className: 'timeline-view',
      p null,
        @props.user

@.EpochUI ?= {}
@.EpochUI.TimelineView = TimelineView

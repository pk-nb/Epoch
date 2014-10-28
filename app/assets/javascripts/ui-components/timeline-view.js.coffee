{div, p, a} = React.DOM

TimelineView = React.createClass
  displayName: 'TimelineView'

  render: ->
    div className: 'timeline-view',
      p null,
        'Hello'
      a href: 'google.com',
        'Link'


@.EpochUI ?= {}
@.EpochUI.TimelineView = TimelineView

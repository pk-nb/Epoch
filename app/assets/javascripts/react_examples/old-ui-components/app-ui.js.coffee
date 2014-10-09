cx = React.addons.classSet

EpochApp = React.createClass
  display: 'EpochApp'

  getInitialState: ->
    barExpanded: false

  render: ->
    # Calculate which bar to expand

    TimelineBar()
    TimelineView()
    EventBar()

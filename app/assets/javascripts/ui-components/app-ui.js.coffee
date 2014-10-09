{div} = React.DOM
# cx = React.addons.classSet

App = React.createClass
  displayName: 'EpochApp'

  getInitialState: ->
    barExpanded: false

  render: ->
    # Calculate which bar to expand
    div className: 'app',
      window.EpochUI.UIBar()
      div className: 'timeline-view',
        'hello'
      # TimelineView(),
      window.EpochUI.UIBar()



@.EpochUI ?= {}
@.EpochUI.App = App

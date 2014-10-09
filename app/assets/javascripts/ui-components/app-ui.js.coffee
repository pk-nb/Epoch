{div} = React.DOM
cx = React.addons.classSet

App = React.createClass
  displayName: 'EpochApp'

  getInitialState: ->
    barExpanded: false

  changeAppState: (data) ->
    @setState barExpanded: data

  render: ->
    # Calculate which bar to expand
    div className: 'app',
      window.EpochUI.UIBar
        id: 'top'
        active: @state.barExpanded is 'top'
        changeAppState: @changeAppState
      div className: 'timeline-view',
        'hello'
      # TimelineView(),
      window.EpochUI.UIBar
        id: 'bottom',
        active: @state.barExpanded is 'bottom'
        changeAppState: @changeAppState



@.EpochUI ?= {}
@.EpochUI.App = App

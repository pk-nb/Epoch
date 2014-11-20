{div} = React.DOM
cx = React.addons.classSet

EpochApp = React.createClass
  displayName: 'EpochApp'

  getInitialState: ->
    barExpanded: false,
    expandedPanel: null

  # Default props that should be set on server render
  getDefaultProps: ->
    user: {name: 'Login', picture: null},
    timelines: [],
    userTimelines: []

  # Change app state by sending this function as a prop on children
  setAppState: (data) ->
    @setState data

  render: ->
    UI = window.EpochUI

    div className: 'app',
      UI.UIPrimaryBar
        id: 'top',
        active: @state.barExpanded is 'top',
        otherActive: @state.barExpanded is 'bottom',
        expandedPanel: @state.expandedPanel
        setAppState: @setAppState,
        user: @props.user
        timelines: @state.timelines || @props.timelines
        userTimelines: @state.userTimelines || @props.userTimelines
      UI.TimelineView
        timelines: @state.timelines || @props.timelines
      UI.UISecondaryBar
        id: 'bottom',
        active: @state.barExpanded is 'bottom',
        otherActive: @state.barExpanded is 'top',
        setAppState: @setAppState,
        expandedPanel: @state.expandedPanel,
        timelines: @state.timelines || @props.timelines


@.EpochApp ?= {}
@.EpochApp = EpochApp

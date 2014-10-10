{div} = React.DOM
cx = React.addons.classSet

App = React.createClass
  displayName: 'EpochApp'

  getInitialState: ->
    barExpanded: false

  # Change app state by sending this function as a prop on children
  setAppState: (data) ->
    @setState data

  render: ->
    UI = window.EpochUI

    div className: 'app',
      UI.UIPrimaryBar
        id: 'top'
        active: @state.barExpanded is 'top'
        setAppState: @setAppState
      UI.TimelineView(),
      UI.UISecondaryBar
        id: 'bottom',
        active: @state.barExpanded is 'bottom'
        setAppState: @setAppState


@.EpochUI ?= {}
@.EpochUI.App = App

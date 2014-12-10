{div} = React.DOM
cx = React.addons.classSet

EpochApp = React.createClass
  displayName: 'EpochApp'

  getInitialState: ->
    barExpanded: false,
    expandedPanel: null,
    selectedEvent: null,
    currentDate: null

# Default props that should be set on server render
  getDefaultProps: ->
    user: {name: 'Login', picture: null},
    timelines: [],
    userTimelines: [],
    event_errors: [], # TODO refactor this so state is only in component
    repos: []

  componentDidUpdate: (prevProps, prevState) ->
    if @state.timelines
      console.log @state.timelines
      @updateURLParams()

  updateURLParams: ->
    newParams = ''
    if @state.timelines.length > 0
      for timeline in @state.timelines
        newParams += "&ids[]=#{timeline.id}"
      newParams = "?" + newParams.slice(1)
    else
      newParams = '?'
    window.History.replaceState(null, 'Epoch', newParams)

# Change app state by sending this function as a prop on children
  setAppState: (data) ->
    # Deselect event if timelines are updated to avoid reference errors

    if data.timelines?
      @setState(selectedEvent: null)

    # Collapse panel if there will be no open event panel
    # TODO This really shouldn't be here, probably give a empty event
    # object to event panel if there is no selected event
    if data.selectedEvent == null and @state.barExpanded == 'bottom'
      @setState(barExpanded: false, expandedPanel: null)

    @setState data

  render: ->
    UI = window.EpochUI
    div className: 'app',
      UI.UIPrimaryBar
        id: 'top'
        active: @state.barExpanded is 'top'
        otherActive: @state.barExpanded is 'bottom'
        expandedPanel: @state.expandedPanel
        setAppState: @setAppState
        user: @props.user
        timelines: @state.timelines || @props.timelines
        userTimelines: @state.userTimelines || @props.userTimelines
        repos: @state.repos || @props.repos
      UI.TimelineView
        timelines: @state.timelines || @props.timelines
        selectedEvent: @state.selectedEvent
        expandedPanel: @state.expandedPanel
        setAppState: @setAppState
        drawExpandedText: !@state.barExpanded
      UI.UISecondaryBar
        id: 'bottom',
        active: @state.barExpanded is 'bottom'
        otherActive: @state.barExpanded is 'top'
        setAppState: @setAppState
        expandedPanel: @state.expandedPanel
        user: @props.user
        timelines: @state.timelines || @props.timelines
        event_errors: @state.event_errors || @props.event_errors
        selectedEvent: @state.selectedEvent
        currentDate: @state.currentDate


@.EpochApp ?= {}
@.EpochApp = EpochApp

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
    userTimelines: [],
    events: [],
    event_errors: [],
    timeline_errors: []

  updateURLParams: ->
    newParams = ''
    if @state.timelines.length > 0
      for timeline in @state.timelines
        newParams += "&ids[]=#{timeline.id}"
      newParams = "?" + newParams.slice(1)
    window.History.replaceState(null, null, newParams)

  # Change app state by sending this function as a prop on children
  setAppState: (data) ->
    # if data.timelines
    #   @updateURLParams(data.timelines)
    @setState data


  componentDidUpdate: (prevProps, prevState) ->
    if @state.timelines
      console.log @state.timelines
      @updateURLParams()

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
        timeline_errors: @state.timeline_errors || @props.timeline_errors
      UI.TimelineView
        timelines: @state.timelines || @props.timelines
      UI.UISecondaryBar
        id: 'bottom',
        active: @state.barExpanded is 'bottom',
        otherActive: @state.barExpanded is 'top',
        setAppState: @setAppState,
        expandedPanel: @state.expandedPanel,
        timelines: @state.timelines || @props.timelines
        events: @state.timelines || @props.timelines
        event_errors: @state.event_errors || @props.event_errors


@.EpochApp ?= {}
@.EpochApp = EpochApp

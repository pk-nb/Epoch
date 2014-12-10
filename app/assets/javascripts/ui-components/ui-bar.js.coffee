{div, button, p, img} = React.DOM
cx = React.addons.classSet
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

UIBarMixin =
  getDefaultProps: ->
    panelIds: {
      timeline: 'timeline',
      newTimeline: 'newTimeline',
      newRepo: 'newRepo',
      newTweet: 'newTweet',
      user: 'user',
      event: 'event',
      newEvent: 'newEvent',
      selectedEvent: 'selectedEvent'
    }

  handleToggle: (panel=null) ->
    if panel == null
      @props.setAppState(barExpanded: false, expandedPanel: null)
    else
      @props.setAppState(barExpanded: @props.id, expandedPanel: panel)

# Returns function (curry) that will be run on click
  handleClick: (panelId=null)->
    =>
      console.log "Hello click " + panelId
      @handleToggle(panelId)


UIPrimaryBar = React.createClass
  displayName: 'UIPrimaryBar'
  mixins: [UIBarMixin]

  render: ->
    # Turn on / off classes for expansion animation with React Class helper
    classes = {
      'ui-bar': true,
      'active': @props.active,
      'other-active': @props.otherActive
    }
    classes[@props.id] = true

    div className: cx(classes),
      div className: 'shelf-content',
        ReactCSSTransitionGroup {transitionName: 'shelf-top'},
          @shelf()
      div className: 'dropdown-content',
        ReactCSSTransitionGroup {transitionName: 'dropdown-top'},
          @dropdownContent()

  dropdownContent: ->
    UI = window.EpochUI
    if @props.expandedPanel == @props.panelIds.user
      UI.UserPanel
        key: 'userPanel',
        user: @props.user
    else if @props.expandedPanel == @props.panelIds.timeline
      # Pass down setAppState as this view can modify top app state
      UI.TimelinePanel
        key: 'timelinePanel',
        user: @props.user
        timelines: @props.timelines
        userTimelines: @props.userTimelines
        repos: @props.repos
        setAppState: @props.setAppState,
        handleClick: @handleClick,
        panelIds: @props.panelIds
    else if @props.expandedPanel == @props.panelIds.newTimeline
      UI.NewTimelinePanel
        key: 'newTimelinePanel',
        timelines: @props.timelines
        userTimelines: @props.userTimelines
        setAppState: @props.setAppState,
        # Calling directly instead of sending callback, so don't need to curry
        goBack: @handleClick(@props.panelIds.timeline)
    else if @props.expandedPanel == @props.panelIds.newRepo
      UI.NewRepoPanel
        key: 'newRepoPanel',
        user: @props.user
        timelines: @props.timelines
        userTimelines: @props.userTimelines
        repos: @props.repos
        setAppState: @props.setAppState
        goBack: @handleClick(@props.panelIds.timeline)
    else if @props.expandedPanel == @props.panelIds.newTweet
      UI.NewTweetPanel
        key: 'newTweetPanel',
        user: @props.user
        timelines: @props.timelines
        userTimelines: @props.userTimelines
        setAppState: @props.setAppState
        goBack: @handleClick(@props.panelIds.timeline)
    else
      # Default Panel set to display: none
      div {key: 'nothing-UIPrimaryBar'}, null

  shelf: ->
    UI = window.EpochUI
    if @props.expandedPanel == @props.panelIds.user
      UI.UserShelf
        key: 'userShelf',
        user: @props.user,
        handleClick: @handleClick,
        panelIds: @props.panelIds
    else if @props.expandedPanel == @props.panelIds.timeline
      UI.TimelineShelf
        key: 'timelineShelf',
        handleClick: @handleClick,
        panelIds: @props.panelIds,
        timelines: @props.timelines
    else if @props.expandedPanel == @props.panelIds.newTimeline
      UI.NewTimelineShelf
        key: 'newTimelineShelf',
        handleClick: @handleClick,
        panelIds: @props.panelIds
    else if @props.expandedPanel == @props.panelIds.newRepo
      UI.NewRepoShelf
        key: 'newRepoShelf',
        handleClick: @handleClick,
        panelIds: @props.panelIds
    else if @props.expandedPanel == @props.panelIds.newTweet
      UI.NewTweetShelf
        key: 'newTweetShelf',
        handleClick: @handleClick,
        panelIds: @props.panelIds
    else
      UI.DefaultTopShelf
        key: 'defaultTopShelf',
        user: @props.user,
        handleClick: @handleClick,
        panelIds: @props.panelIds,
        timelines: @props.timelines


UISecondaryBar = React.createClass
  displayName: 'UISecondaryBar'
  mixins: [UIBarMixin]

  render: ->
    # Turn on / off classes for expansion animation with React Class helper
    classes = {
      'ui-bar': true,
      'active': @props.active,
      'other-active': @props.otherActive
    }

    classes[@props.id] = true

    div className: cx(classes),
      div className: 'shelf-content',
        ReactCSSTransitionGroup {transitionName: 'shelf-bottom'},
          @shelf()
      div className: 'dropdown-content',
        ReactCSSTransitionGroup {transitionName: 'dropdown-bottom'},
          @dropdownContent()

  eventForSelectedEvent: ->
    if @props.selectedEvent
      @props.timelines[@props.selectedEvent.tIndex].events[@props.selectedEvent.eIndex]
    # else
    #   null

  shelf: ->
    UI = window.EpochUI
    if @props.expandedPanel == @props.panelIds.newEvent
      UI.NewEventShelf
        key: 'newEventShelf',
        handleClick: @handleClick,
        panelIds: @props.panelIds
    else if @props.expandedPanel == @props.panelIds.event and @props.selectedEvent?

      UI.EventShelf
        key: 'eventShelf'
        handleClick: @handleClick,
        panelIds: @props.panelIds
        selectedEvent: @props.timelines[@props.selectedEvent.tIndex].events[@props.selectedEvent.eIndex]
    else if @props.selectedEvent
      UI.SelectedEventShelf
        key: 'selectedEventShelf'
        handleClick: @handleClick,
        panelIds: @props.panelIds
        selectedEvent: @props.timelines[@props.selectedEvent.tIndex].events[@props.selectedEvent.eIndex]
    else
      UI.DefaultBottomShelf
        key: 'defaultBottomShelf'
        handleClick: @handleClick
        user: @props.user
        panelIds: @props.panelIds
        currentDate: @props.currentDate

  dropdownContent: ->
    UI = window.EpochUI
    if @props.expandedPanel == @props.panelIds.newEvent
      UI.NewEventPanel
        key: 'newEventPanel',
        user: @props.user,
        timelines: @props.timelines,
        setAppState: @props.setAppState,
        events: @props.events
        event_errors: @props.event_errors
    else if @props.expandedPanel == @props.panelIds.event
      UI.EventPanel
        key: 'eventPanel'
        handleClick: @handleClick,
        panelIds: @props.panelIds
        selectedEvent: @props.timelines[@props.selectedEvent.tIndex].events[@props.selectedEvent.eIndex]
    else
      # Default Panel set to display: none
      div {key: 'nothing-UIBottomBar'}, null


@.EpochUI ?= {}
@.EpochUI.UIPrimaryBar = UIPrimaryBar
@.EpochUI.UISecondaryBar = UISecondaryBar

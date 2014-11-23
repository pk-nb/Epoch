{div, button, p, img} = React.DOM
cx = React.addons.classSet
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

UIBarMixin =
  getDefaultProps: ->
    panelIds: {
      timeline: 'timeline',
      user: 'user',
      event: 'event',
      newEvent: 'newEvent'
    }

  handleToggle: (panel=null) ->
    if @props.active
      @props.setAppState(barExpanded: false, expandedPanel: null)
    else
      @props.setAppState(barExpanded: @props.id, expandedPanel: panel)

  # Returns function (curry) that will be run on click
  handleClick: (panelId=null)->
    =>
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
        timeline_errors: @props.timeline_errors
        events: @props.events
        setAppState: @props.setAppState
    else
      # Default Panel set to display: none
      div {key: 'nothing'}, null

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

  shelf: ->
    UI = window.EpochUI
    if @props.expandedPanel == @props.panelIds.newEvent
      UI.NewEventShelf
        key: 'newEventShelf',
        handleClick: @handleClick,
        panelIds: @props.panelIds
    else
      UI.DefaultBottomShelf
        key: 'defaultBottomShelf',
        handleClick: @handleClick,
        panelIds: @props.panelIds


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
    else
      # Default Panel set to display: none
      div {key: 'nothing'}, null



@.EpochUI ?= {}
@.EpochUI.UIPrimaryBar = UIPrimaryBar
@.EpochUI.UISecondaryBar = UISecondaryBar

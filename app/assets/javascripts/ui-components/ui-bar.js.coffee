{div, button, p, img} = React.DOM
cx = React.addons.classSet
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

UIBarMixin =
  getDefaultProps: ->
    panelIds: {
      timeline: 'timeline',
      user: 'user'
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
    else
      UI.DefaultTopShelf
        key: 'defaultTopShelf',
        user: @props.user,
        handleClick: @handleClick,
        panelIds: @props.panelIds


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
      div className: 'dropdown-content',
        ReactCSSTransitionGroup {transitionName: 'dropdown-bottom'},
          div {key: 'nothing'}, null
      div className: 'shelf-content',
        div className: 'shelf',
          div className: 'left',
            p { onClick: @handleToggle, className: 'dropdown-link'},
              'Event Name'
          div className: 'center',
            p { onClick: @handleToggle, className: 'dropdown-link'},
              '1999'
          div className: 'right',
            p { onClick: @handleToggle, className: 'dropdown-link' },
              '+'


@.EpochUI ?= {}
@.EpochUI.UIPrimaryBar = UIPrimaryBar
@.EpochUI.UISecondaryBar = UISecondaryBar

{div, button, p, img} = React.DOM
cx = React.addons.classSet
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup;

UIBarMixin =
  handleToggle: (panel=null) ->
    if @props.active
      @props.setAppState(barExpanded: false, expandedPanel: null)
    else
      @props.setAppState(barExpanded: @props.id, expandedPanel: panel)


UIPrimaryBar = React.createClass
  displayName: 'UIPrimaryBar'
  mixins: [UIBarMixin]

  getInitialState: ->
    dropdownPanel: null

  getDefaultProps: ->
    panelIds: {
      timeline: 'timeline',
      user: 'user'
    }

  # Returns function (curry) that will be run on click
  handleClick: (panelId=null)->
    =>
      @handleToggle(panelId)

  render: ->
    # Create class list with React Addon class helper
    classes = {
      'ui-bar': true,
      'active': @props.active,
      'other-active': @props.otherActive
    }
    classes[@props.id] = true


    div className: cx(classes),
      @shelf(),
      div className: 'dropdown-content',
        ReactCSSTransitionGroup {transitionName: 'dropdown-top'},
          @dropdownContent()

  dropdownContent: ->
    UI = window.EpochUI
    if @props.expandedPanel == @props.panelIds.user
      UI.UserPanel
        user: @props.user
        key: 'userPanel'
    else
      # Default Panel set to display: none
      div {key: 'nothing'}, null

  shelf: ->
    UI = window.EpochUI
    if @props.expandedPanel == @props.panelIds.user
      UI.UserShelf
        user: @props.user,
        handleClick: @handleClick
        panelIds: @props.panelIds
    else
      UI.DefaultTopShelf
        user: @props.user,
        handleClick: @handleClick
        panelIds: @props.panelIds


  # user: ->
  #   if @props.user
  #     div null,
  #       img {className: 'avatar', src: @props.user.picture}
  #       p { onClick: @handleUserClick, className: 'dropdown-link' },
  #         @props.user.name
  #   else
  #     p { onClick: @handleUserClick, className: 'dropdown-link' },
  #       'Login'


UISecondaryBar = React.createClass
  displayName: 'UISecondaryBar'
  mixins: [UIBarMixin]

  render: ->
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

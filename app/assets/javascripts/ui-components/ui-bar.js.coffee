{div, button, p} = React.DOM
cx = React.addons.classSet

UIBarMixin =
  handleToggle: ->
    if @props.active
      @props.setAppState(barExpanded: false)
    else
      @props.setAppState(barExpanded: @props.id)


UIPrimaryBar = React.createClass
  displayName: 'UIPrimaryBar'
  mixins: [UIBarMixin]

  render: ->
    classes = { 'ui-bar': true, 'active': @props.active }
    classes[@props.id] = true

    div className: cx(classes),
      div className: 'shelf',
        div className: 'left logo',
          p null,
            'Epoch'
        div className: 'center',
          p { onClick: @handleToggle, className: 'timeline-dropdown'},
            'Timeline Title'
        div className: 'right',
          p { onClick: @handleToggle, className: 'user-dropdown' },
            'User'
      div className: 'dropdown-content',
        p null,
          'HI'


UISecondaryBar = React.createClass
  displayName: 'UISecondaryBar'
  mixins: [UIBarMixin]

  render: ->
    classes = { 'ui-bar': true, 'active': @props.active }
    classes[@props.id] = true

    div className: cx(classes),
      div null,
        'SECOND'
      button onClick: @handleToggle,
        'Super Toggle'


@.EpochUI ?= {}
@.EpochUI.UIPrimaryBar = UIPrimaryBar
@.EpochUI.UISecondaryBar = UISecondaryBar

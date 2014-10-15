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
    classes = {
      'ui-bar': true,
      'active': @props.active,
      'other-active': @props.otherActive
    }

    classes[@props.id] = true

    div className: cx(classes),
      div className: 'shelf',
        div className: 'left logo',
          p null,
            'Epoch'
        div className: 'center',
          p { onClick: @handleToggle, className: 'dropdown-link'},
            'Timeline Title'
        div className: 'right',
          p { onClick: @handleToggle, className: 'dropdown-link' },
            'User'
      div className: 'dropdown-content',
        p null,
          'HI'


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
        p null,
          'HI'
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

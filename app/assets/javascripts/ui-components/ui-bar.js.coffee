{div, button} = React.DOM
cx = React.addons.classSet

UIBar = React.createClass
  displayName: 'UIBar'

  handleToggle: ->
    if @props.active
      @props.setAppState(barExpanded: false)
    else
      @props.setAppState(barExpanded: @props.id)

  render: ->
    classes = { 'ui-bar': true, 'active': @props.active }
    classes[@props.id] = true

    div className: cx(classes),
      button onClick: @handleToggle,
        'Super Toggle'


@.EpochUI ?= {}
@.EpochUI.UIBar = UIBar

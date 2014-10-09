{div, button} = React.DOM
cx = React.addons.classSet

UIBar = React.createClass
  displayName: 'UIBar'

  handleToggle: ->
    if @props.active
      @props.changeAppState(false)
    else
      @props.changeAppState(@props.id)

  render: ->
    classes = cx('ui-bar': true, 'active': @props.active)

    div className: classes,
      button onClick: @handleToggle,
        'Super Toggle'





@.EpochUI ?= {}
@.EpochUI.UIBar = UIBar

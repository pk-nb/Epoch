{div, button} = React.DOM

cx = React.addons.classSet

UIBar = React.createClass
  displayName: 'UIBar'

  getInitialState: ->
    active: false,
    buttons: ['Button']

  handleToggle: ->
    @setState active: !@state.active


  render: ->
    classes = cx('ui-bar': true, 'active': @state.active)

    div { className: classes },
      button (onClick: @handleToggle),
        'Toggle'



@.EpochUI ?= {}
@.EpochUI.UIBar = UIBar

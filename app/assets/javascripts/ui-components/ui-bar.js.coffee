{div, button} = React.DOM
cx = React.addons.classSet


# Pubsub Identifiers
MESSAGE_NAME = 'UIBar'


UIBar = React.createClass
  displayName: 'UIBar'

  getInitialState: ->
    active: false,
    buttons: ['Button']

  componentDidMount: ->
    # If given message prop and pubsub exists, we subscribe to changes
    window.EpochApp.Pubsub.sub(@props.message)



  handleToggle: ->
    @setState active: !@state.active
    window.EpochApp.State
    # If we have a message and pubsub exists, we publish changes


  render: ->
    classes = cx('ui-bar': true, 'active': @state.active)

    div { className: classes },
      button (onClick: @handleToggle),
        'Toggle'



@.EpochUI ?= {}
@.EpochUI.UIBar = UIBar

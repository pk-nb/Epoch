{div, button} = React.DOM
cx = React.addons.classSet

UIBar = React.createClass
  displayName: 'UIBar'

  getInitialState: ->
    active: false,
    buttons: ['Button']

  componentDidMount: ->
    # If given message prop and pubsub exists, we subscribe to changes
    window.EpochApp.Pubsub.sub @props.id, @props.channel, @handleAppStateChange


  handleAppStateChange: (barState) ->
    console.log "from #{@props.id}: #{barState}"
    if barState is @props.id
      @setState active: true
    else
      @setState active: false
    # else if barState is not false
      # @setState active: true


  handleToggle: ->
    if @state.active
      window.EpochApp.State.barExtended = false
    else
      window.EpochApp.State.barExtended = @props.id

    # @setState active: !@state.active
    window.EpochApp.Pubsub.pub @props.channel, window.EpochApp.State.barExtended


    # If we have a message and pubsub exists, we publish changes


  render: ->
    classes = cx('ui-bar': true, 'active': @state.active)

    div { className: classes },
      button (onClick: @handleToggle),
        'Toggle'



@.EpochUI ?= {}
@.EpochUI.UIBar = UIBar

{div, a, p} = React.DOM

UserPanel = React.createClass
  displayName: 'UserPanel'

  render: ->
    div null,
      p null,
        @props.user.name


@.EpochUI ?= {}
@.EpochUI.UserPanel = UserPanel

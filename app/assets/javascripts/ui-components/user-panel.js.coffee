{div, h1, a, p, img} = React.DOM

UserPanel = React.createClass
  displayName: 'UserPanel'

  render: ->
    div className: 'panel user-panel',
      if @props.user then @userPanel() else @loginPanel()


  loginPanel: ->
    div null,
      h1 null,
        'Login'
      a { href: '/auth/facebook', id: 'sign_in_facebook', className: 'button' },
        'Sign in with Facebook'
      a { href: '/auth/github', id: 'sign_in_github', className: 'button' },
        'Sign in with Github'
      a { href: '/auth/google_oauth2', id: 'sign_in_google', className: 'button' },
        'Sign in with Google'
      a { href: '/auth/twitter', id: 'sign_in_twitter', className: 'button' },
        'Sign in with Twitter'


  userPanel: ->
    div className: 'logged-in',
      img { className: 'avatar', src: @props.user.picture }
      p null,
        @props.user.name
      a { href: Routes.logout_path() },
        'Logout'


@.EpochUI ?= {}
@.EpochUI.UserPanel = UserPanel

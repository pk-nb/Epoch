{div, a, p,img} = React.DOM

UserPanel = React.createClass
  displayName: 'UserPanel'

  render: ->
    if @props.user
      @userPanel()
    else
      @loginPanel()


  loginPanel: ->
    div null,
      p null,
        'Login in with'
      a { href: '/auth/facebook', id: 'sign_in_facebook' },
        'Sign in with Facebook'
      a { href: '/auth/github', id: 'sign_in_github' },
        'Sign in with Github'
      a { href: '/auth/google_oauth2', id: 'sign_in_google' },
        'Sign in with Google'
      a { href: '/auth/twitter', id: 'sign_in_twitter' },
        'Sign in with Twitter'


  userPanel: ->
    div null,
      img { className: 'avatar', src: @props.user.picture }
      p null,
        @props.user.name
      a { href: Routes.logout_path() },
        'Logout'


@.EpochUI ?= {}
@.EpochUI.UserPanel = UserPanel

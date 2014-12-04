{div, h1, a, p, img} = React.DOM

UserPanel = React.createClass
  displayName: 'UserPanel'

  render: ->
    div className: 'panel-container user-panel',
      div className: 'panel',
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
      div null,
        a { href: Routes.logout_path() },
          'Logout'
        @accountLink('facebook', 'sign_in_facebook', 'Facebook'),
        @accountLink('github', 'sign_in_github', 'Github'),
        @accountLink('google_oauth2', 'sign_in_google', 'Google'),
        @accountLink('twitter', 'sign_in_twitter', 'Twitter')

  accountLink: (loginId, cssId, serviceName) ->
    if loginId in @props.user.providers
      # TODO style this better
      p null,
        "Logged in with #{serviceName}"
    else
      a { href: "/auth/#{loginId}", id: cssId, className: 'button' },
        "Link account with #{serviceName}"


@.EpochUI ?= {}
@.EpochUI.UserPanel = UserPanel

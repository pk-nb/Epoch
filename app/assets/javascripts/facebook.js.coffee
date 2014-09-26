jQuery ->
  $('body').prepend('<div id="fb-root"></div>')

  $.ajax
    url: "#{window.location.protocol}//connect.facebook.net/en_US/all.js"
    dataType: 'script'
    cache: true


window.fbAsyncInit = ->
  FB.init(appId: '322861781229311',
    cookie: true,
    xfbml : false,
    version : 'v2.1')

  $('#sign_in_facebook').click (e) ->
    e.preventDefault()
    FB.login (response) ->
      if response.authResponse
        url = '/auth/facebook/callback?'
        url += $.param(signed_request: response.authResponse.signedRequest)
        window.location = url

  $('#sign_out').click (e) ->
    FB.getLoginStatus (response) ->
      if(response.status == 'connected')
        FB.logout()
    true
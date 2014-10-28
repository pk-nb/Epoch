# Fix super special click events being fired in addition to tap events
# with fastclick library.
window.addEventListener 'load', ->
  FastClick.attach(document.body)

document.ontouchmove = (event) ->
    event.preventDefault();

React.initializeTouchEvents(true)

appNode = document.getElementById('epoch-app')

React.renderComponent(@.EpochApp(), appNode) unless appNode is null

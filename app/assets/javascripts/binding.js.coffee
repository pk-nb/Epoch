# Fix super special click events being fired in addition to tap events
# with fastclick library.
window.addEventListener 'load', ->
  FastClick.attach(document.body)

React.initializeTouchEvents(true)

appNode = document.getElementById('epoch-app')

React.renderComponent(@.EpochApp(), appNode) unless appNode is null

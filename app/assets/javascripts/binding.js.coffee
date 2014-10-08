timeline = [
  {name: "Life of Einstein"}
  {name: "Life of Isaac Hermens"}
  {name: "The Best Timeline Ever"}
  {name: "Chicago World Fairs"}
  {name: "Classical Composers"}
]

@.EpochApp ?= {}
@.EpochApp.Pubsub = new @.EpochModel.Pubsub

topBar = document.getElementById('top-bar')
bottomBar = document.getElementById('bottom-bar')
React.renderComponent(@.EpochUI.UIBar(message: 'topBar'), topBar)
React.renderComponent(@.EpochUI.UIBar(message: 'bottomBar'), bottomBar)

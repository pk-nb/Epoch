timeline = [
  {name: "Life of Einstein"}
  {name: "Life of Isaac Hermens"}
  {name: "The Best Timeline Ever"}
  {name: "Chicago World Fairs"}
  {name: "Classical Composers"}
]

@.EpochApp ?= {}
@.EpochApp.Pubsub = new @.EpochModel.Pubsub
@.EpochApp.State = { barExtended: false }

topBar = document.getElementById('top-bar')
bottomBar = document.getElementById('bottom-bar')
React.renderComponent(@.EpochUI.UIBar(id: 'topBar', channel: 'UIBars'), topBar)
React.renderComponent(@.EpochUI.UIBar(id: 'bottomBar', channel: 'UIBars'), bottomBar)

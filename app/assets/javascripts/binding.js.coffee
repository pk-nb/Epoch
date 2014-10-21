appNode = document.getElementById('epoch-app')

React.renderComponent(@.EpochUI.App({user: 'non-existant user'}), appNode) unless appNode is null

{div, button} = React.DOM

ReactCSSTransitionGroup = React.addons.CSSTransitionGroup

TodoList = React.createClass
  displayName: 'TodoList'
  getInitialState: ->
    items: ['hello', 'world', 'click', 'me']

  handleAdd: ->
    newValue = prompt 'Enter some text'
    newItems = @state.items.concat [newValue]
    @setState items: newItems

  handleRemove: (i) ->
    newItems = @state.items
    newItems.splice(i, 1)
    @setState items: newItems

  render: ->
    items = @state.items.map (item, i) =>
      div {key: item, onClick: @handleRemove.bind(null, i)},
        item

    div null,
      button {onClick: @handleAdd},
        'Add Item'
      ReactCSSTransitionGroup {transitionName: 'example'},
        [items]

@.EpochUI ?= {}
@.EpochUI.TodoList = TodoList

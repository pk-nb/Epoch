timeline = [
  {name: "Life of Einstein"}
  {name: "Life of Isaac Hermens"}
  {name: "The Best Timeline Ever"}
  {name: "Chicago World Fairs"}
  {name: "Classical Composers"}
]


TimelineItem = React.createClass
  render: ->
      React.DOM.li({}, @props.timeline.name)

TimelineSearch = React.createClass
  getInitialState: ->
    search: ''

  setSearch: (event) ->
    @setState(search: event.target.value)

  timelines: ->
    @props.timelines.filter(
      (timeline) => timeline.name.indexOf(@state.search) > -1
    )

  searchInput: ->
    React.DOM.input({
      name: 'search'
      onChange: @setSearch
      placeholder: 'Search...'
    })

  timelineList: ->
    React.DOM.ul({}, [
      for timeline in @timelines()
        TimelineItem({timeline: timeline})
    ])

  render: ->
    React.DOM.div({},
      @searchInput(),
      @timelineList()
    )

appNode = document.getElementById('main')
React.renderComponent(TimelineSearch(timelines: timeline), appNode)

R = React.DOM

timeline = [
  {name: "Life of Einstein"}
  {name: "Life of Isaac Hermens"}
  {name: "The Best Timeline Ever"}
  {name: "Chicago World Fairs"}
  {name: "Classical Composers"}
]


TimelineItem = React.createClass
  displayName: 'TimelineItem'
  render: ->
    R.li {}, @props.timeline.name

TimelineSearch = React.createClass
  displayName: 'TimelineSearch'
  getInitialState: ->
    search: ''

  setSearch: (event) ->
    @setState(search: event.target.value)

  timelines: ->
    @props.timelines.filter(
      (timeline) => timeline.name.indexOf(@state.search) > -1
    )

  searchInput: ->
    R.input
      name: 'search'
      onChange: @setSearch,
      placeholder: 'Search Timelines...'

  timelineList: ->
    R.ul null, [
      for timeline in @timelines()
        TimelineItem({timeline: timeline})
    ]

  render: ->
    R.div {},
      @searchInput(),
      @timelineList()

appNode = document.getElementById('main')
React.renderComponent(TimelineSearch(timelines: timeline), appNode)

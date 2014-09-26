# @cjsx React.DOM

timeline = [
  {name: "Life of Einstein"}
  {name: "Life of Isaac Hermens"}
  {name: "The Best Timeline Ever"}
  {name: "Chicago World Fairs"}
  {name: "Classical Composers"}
]


TimelineItem = React.createClass
  render: ->
    <li>{@props.timeline.name}</li>
      # React.DOM.li({}, @props.timeline.name)


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
    <input
      name='search'
      onChange={@setSearch}
      placeholder='Search...'
    />

  timelineList: ->
    <ul>
      {@timelines().map (timeline) -> <TimelineItem key={timeline.id} data={timeline: timeline} />}
        #  TimelineItem({timeline: timeline})}
    </ul>
    # React.DOM.ul(null, [
    #   for timeline in @timelines()
    #     TimelineItem({timeline: timeline})
    # ])

  render: ->
    # {@searchInput}
    # {@timelineList}
    # <timelineList />
    React.DOM.div({},
      @searchInput(),
      @timelineList()
    )

appNode = document.getElementById('main')
React.renderComponent(TimelineSearch(timelines: timeline), appNode)

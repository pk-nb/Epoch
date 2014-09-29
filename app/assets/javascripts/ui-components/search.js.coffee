{li, input, ul, div} = React.DOM

TimelineItem = React.createClass
  displayName: 'TimelineItem'
  render: ->
    li null, @props.timeline.name

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
    input
      name: 'search'
      onChange: @setSearch,
      placeholder: 'Search Timelines...'

  timelineList: ->
    ul null, [
      for timeline in @timelines()
        TimelineItem({timeline: timeline})
    ]

  render: ->
    div null,
      @searchInput(),
      @timelineList()

# Export functions to window under global namespace
@.EpochUI ?= {}
# @.EpochUI.TimelineItem = TimelineItem
@.EpochUI.TimelineSearch = TimelineSearch

{div, form, button, p, h1, hr} = React.DOM

TimelinePanel = React.createClass
  displayName: 'TimelinePanel'

  onPostSuccess: (data) ->
    console.log data
    console.log @props.timelines
    timelines = @props.timelines
    timelines.push(data)

    @props.setAppState(timelines: timelines)

  onPostError: (data) ->
    # Render error by setting state
    console.log 'Ajax failure'
    console.log(data)


  handleSubmit: (e) ->
    console.log 'Submit form'
    e.preventDefault()
    $.ajax {
      type: 'POST',
      url: Routes.timelines_path(),
      data: $(@refs.newTimelineForm.getDOMNode()).serialize(),
      dataType: 'json'

      success: (data, status, xhr) =>
        console.log 'Ajax success'
        @onPostSuccess(data)

      error: (xhr, status, error) =>
        console.log status
        @onPostError(error)

        # console.log error
    }

  userTimelines: ->
    if @props.user
      div null,
        h1 null,
          "#{@props.user.name}'s Timelines"
        @userTimelineList()

  userTimelineList: ->
    @props.userTimelines.map (timeline) =>
      p {key: timeline.title + timeline.id},
        timeline.title


  timelineList: ->
    if @props.timelines.length > 0
      @props.timelines.map (timeline) =>
        p {key: timeline.title},
          timeline.title
    else
      p null,
        'No Selected Timelines'

  render: ->
    Forms = window.EpochForms
    div className: 'panel timeline-panel',
      h1 null,
        'Selected Timelines'
      @timelineList(),
      @userTimelines(),
      # h1 null,
      #   'My Timelines'
      h1 null,
        'New Timeline'
      form ref: 'newTimelineForm', onSubmit: @handleSubmit,
        div dangerouslySetInnerHTML: { __html: Forms.newTimeline },
          null
        button null,
          'Submit'


@.EpochUI ?= {}
@.EpochUI.TimelinePanel = TimelinePanel

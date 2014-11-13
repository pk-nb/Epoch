{div, form, button, p, h1, hr} = React.DOM

TimelinePanel = React.createClass
  displayName: 'TimelinePanel'

  onPostSuccess: (data) ->
    console.log data
    console.log @props.timelines
    timelines = @props.timelines
    timelines.push(data)

    @props.setAppState(timelines: timelines)



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

      error: (xhr, status, error) ->
        console.log 'Ajax failure'
        console.log status
        console.log error
    }


  timelineList: ->
    @props.timelines.map (timeline) =>
      p {key: timeline.title},
        timeline.title

  render: ->
    Forms = window.EpochForms
    div className: 'panel timeline-panel',
      h1 null,
        'Selected Timelines'
      @timelineList(),
      h1 null,
        'New Timeline'
      form ref: 'newTimelineForm', onSubmit: @handleSubmit,
        div dangerouslySetInnerHTML: { __html: Forms.newTimeline },
          null
        button null,
          'Submit'


@.EpochUI ?= {}
@.EpochUI.TimelinePanel = TimelinePanel

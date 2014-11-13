{div, form, button, p, h1, hr} = React.DOM

TimelinePanel = React.createClass
  displayName: 'TimelinePanel'

  handleSubmit: (e) ->
    console.log 'Submit form'
    e.preventDefault()
    # $.post Routes.timelines_path(), $(@refs.newTimelineForm.getDOMNode()).serialize(), (data) ->
    #     console.log data
    $.ajax {
      type: 'POST',
      url: Routes.timelines_path(),
      data: $(@refs.newTimelineForm.getDOMNode()).serialize(),
      dataType: 'json'

      success: (data, status, xhr) ->
        console.log 'Ajax success'
        console.log data
        console.log status

      error: (xhr, status, error) ->
        console.log 'Ajax failure'
        console.log status
        console.log error
    }


  timelineList: ->
    Object.keys(@props.timelines).map (key) =>
      p {key: @props.timelines[key].title},
        @props.timelines[key].title

  render: ->
    Forms = window.EpochForms
    div className: 'panel timeline-panel',
      h1 null,
        'Selected Timelines'
      @timelineList(),
      h1 null,
        'New Timeline'
      form ref: 'newTimelineForm', onSubmit: @handleSubmit,
        div dangerouslySetInnerHTML: {__html: Forms.newTimeline },
          null
        button null,
          'Submit'


@.EpochUI ?= {}
@.EpochUI.TimelinePanel = TimelinePanel

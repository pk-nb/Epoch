{div, form, button, p, h1, hr} = React.DOM

NewEventPanel = React.createClass
  displayName: 'NewEventPanel'

  onPostSuccess: (data) ->
    # console.log data
    # console.log @props.timelines
    # timelines = @props.timelines
    # timelines.push(data)
    #
    # @props.setAppState(timelines: timelines)

  onPostError: (data) ->
    # Render error by setting state
    # console.log 'Ajax failure'
    # console.log(data)

  handleSubmit: (e) ->
    console.log 'Submit new event form'
    e.preventDefault()
    # $.ajax {
    #   type: 'POST',
    #   url: Routes.timelines_path(),
    #   data: $(@refs.newTimelineForm.getDOMNode()).serialize(),
    #   dataType: 'json'
    #
    #   success: (data, status, xhr) =>
    #     console.log 'Ajax success'
    #     @onPostSuccess(data)
    #
    #   error: (xhr, status, error) ->
    #     console.log 'Ajax failure'
    #     console.log status
    #     console.log error
    # }


  # timelineList: ->
  #   if @props.timelines
  #     @props.timelines.map (timeline) =>
  #       p {key: timeline.title},
  #         timeline.title

  render: ->
    Forms = window.EpochForms
    div className: 'panel',
      h1 null,
        'New Event'
      form ref: 'newEventForm', onSubmit: @handleSubmit,
        div dangerouslySetInnerHTML: { __html: Forms.newEvent },
          null
        button null,
          'Submit'


@.EpochUI ?= {}
@.EpochUI.NewEventPanel = NewEventPanel

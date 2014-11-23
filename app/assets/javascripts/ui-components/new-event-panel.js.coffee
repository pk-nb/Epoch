{div, form, button, p, h1, hr, select, option} = React.DOM

NewEventPanel = React.createClass
  displayName: 'NewEventPanel'

  onPostSuccess: (data) ->
    # todo IJH 11/23/14, I'm not entirely sure what our desired behavior is at this point in time...need to consult Nathanael.
    console.log data
    console.log @props.events
    events = @props.events
    events.push(data)
    @props.setAppState(events: events)

  onPostError: (messages) ->
    # Render error by setting state
    console.log 'Ajax failure'
    console.log(messages)
    @props.setAppState(event_errors: messages)

  handleSubmit: (e) ->
    console.log 'Submit new event form'
    e.preventDefault()
    $.ajax {
      type: 'POST',
      url: Routes.events_path(),
      data: $(@refs.newEventForm.getDOMNode()).serialize(),
      dataType: 'json'

      success: (data, status, xhr) =>
        console.log 'Ajax success'
        @onPostSuccess(data)

      error: (xhr, status, error) =>
        console.log 'Ajax failure'
        console.log status
        console.log error
        # Retrieve/parse error messages from response text
        messages = [];
        try messages = JSON.parse(xhr.responseText).errors
        catch e then messages = [xhr.responseText]
        @onPostError(messages)
    }

  renderErrors: ->
    div className: 'form-errors',
      @props.event_errors.map (error) =>
        p null,
          error

  render: ->
    Forms = window.EpochForms
    div className: 'panel',
      h1 null,
        'New Event'
      @renderErrors()
      form ref: 'newEventForm', onSubmit: @handleSubmit,
        select {name: 'timeline_id'},
          @props.timelines.map (timeline) =>
            option value: timeline.id,
              timeline.title
        div dangerouslySetInnerHTML: { __html: Forms.newEvent },
          null
        button null,
          'Submit'

@.EpochUI ?= {}
@.EpochUI.NewEventPanel = NewEventPanel

class EventsController < ApplicationController
  def index
    @events = timeline.events

    respond_to do |format|
      format.html
      format.json {render json: @events}
    end
  end
  
  def show
    @event = timeline.events.find(params[:id])
    respond_to do |format|
      format.html
      format.json {render json: @event}
    end
  end

  def new
    @timeline = timeline
    @event = Event.new
    respond_to do |format|
      format.html
      format.json {render json: @event}
    end
  end

  def create
    timeline.events.create(event_params.merge(user_id: current_user.id))
    respond_to do |format|
      format.html { redirect_to timeline_events_path }
      format.json {render json: @event}
    end
  end

  def edit
    @timeline = timeline
    @event = current_user.events.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @event }
    end
  end

  def update
    current_user.events.find(params[:id]).tap do |event|
      event.update!(event_params)
    end
    respond_to do |format|
      format.html { redirect_to timeline_event_path }
      format.json { render json: @event }
    end
  end

  def destroy
    event = current_user.events.destroy(params[:id])
    respond_to do |format|
      format.html {redirect_to timeline_events_path}
      format.json
    end
  end

  private
  def event_params
    params.require(:event).permit(:title, :content, :start_date, :end_date)
  end

  def timeline
    current_user.timelines.find(params[:timeline_id])
  end

end

class EventsController < ApplicationController
  def index
    @events = timeline.events
  end
  
  def show
    @event = timeline.events.find(params[:id])
  end

  def new
    @timeline = timeline
    @event = Event.new
  end

  def create
    timeline.events.create(event_params.merge(user_id: current_user.id))
    redirect_to timeline_events_path
  end

  def edit
    @timeline = timeline
    @event = current_user.events.find(params[:id])
  end

  def update
    current_user.events.find(params[:id]).tap do |event|
      event.update!(event_params)
    end
    redirect_to timeline_event_path
  end

  def destroy
    current_user.events.destroy(params[:id])
    redirect_to root_path
  end

  private
  def event_params
    params.require(:event).permit(:title, :content, :start_date, :end_date)
  end

  def timeline
    current_user.timelines.find(params[:timeline_id])
  end

end

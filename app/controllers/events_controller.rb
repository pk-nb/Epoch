class EventsController < ApplicationController
  def index

  end
  
  def show
  end

  def new
    @timeline = Timeline.find(params[:timeline_id])
    @event = Event.new
  end

  def create
    params.permit!
    timeline = Timeline.find(params[:timeline_id])
    timeline.events.create(params[:event].merge(user_id: current_user.id))
    redirect_to root_path
  end

  def edit
    @event = current_user.events.find(params[:id])
  end

  def update
    params.permit!
    current_user.events.find(params[:id]).tap do |event|
      event.update!(params[:event])
    end
    redirect_to root_path
  end

  def destroy
    Event.destroy(params[:id])
    redirect_to root_path
  end

end

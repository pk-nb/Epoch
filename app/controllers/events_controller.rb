class EventsController < ApplicationController
  before_action :require_login
  def index
    @events = @timeline.events

    respond_to do |format|
      format.json {render json: @events}
    end
  end
  
  def show
    @event = current_user.events.find(params[:id])
    respond_to do |format|
      format.json {render json: @event}
    end
  end

  def new
    @event = Event.new
    respond_to do |format|
      format.json {render json: @event}
    end
  end

  def create
    @timeline = current_user.timelines.find(params.require(:timeline_id))
    @event = @timeline.events.create(event_params.merge(user_id: current_user.id, event_type: 'Epoch'))
    respond_to do |format|
      format.json do
        if @event.valid?
          render json: @event
        else
          render json: {errors: @event.errors.full_messages}, status: 422
        end
      end
    end
  end

  def edit
    @event = current_user.events.find(params[:id])
    respond_to do |format|
      format.json { render json: @event }
    end
  end

  def update
    current_user.events.find(params[:id]).tap do |event|
      event.update!(event_params)
    end
    respond_to do |format|
      format.json do
        if @event.valid?
          render json: @event
        else
          render json: {errors: @event.errors.full_messages}, status: 422
        end
      end
    end
  end

  def destroy
    current_user.events.destroy(params[:id])
    respond_to do |format|
      format.json {true}
    end
  end

  private
  def event_params
    params.require(:event).permit(:title, :content, :start_date, :end_date)
  end
end

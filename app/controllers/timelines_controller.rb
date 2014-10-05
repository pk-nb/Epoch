class TimelinesController < ApplicationController
  before_action :require_login
  
  def index
    @timelines = current_user.timelines
  end
  
  def show
    @timeline = current_user.timelines.find(params[:id])
  end
  
  def new
    @timeline = Timeline.new
  end
  
  def create
    current_user.timelines.create(timeline_params)
    redirect_to timelines_path
  end
  
  def edit
    @timeline = current_user.timelines.find(params[:id])
  end
  
  def update
    @timeline = current_user.timelines.find(params[:id]).tap do |timeline|
      timeline.update!(timeline_params)
    end
    redirect_to timelines_path
  end
  
  def destroy
    timeline = current_user.timelines.destroy(params[:id])
    redirect_to timelines_path
  end
  
  private
  def timeline_params
    params.require(:timeline).permit(:title, :content, :start_date, :end_date)
  end
end

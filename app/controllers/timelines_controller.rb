class TimelinesController < ApplicationController
  before_action :require_login
  
  def index
    @timelines = current_user.timelines
    
    respond_to do |format|
      format.html
      format.json { render json: @timelines }
    end
  end
  
  def show
    @timeline = current_user.timelines.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @timeline }
    end
  end
  
  def new
    @timeline = Timeline.new
    respond_to do |format|
      format.html
      format.json { render json: @timeline }
    end
  end
  
  def create
    @timeline = current_user.timelines.create(timeline_params)
    respond_to do |format|
      format.html { redirect_to timelines_path }
      format.json { render json: @timeline }
    end
  end
  
  def edit
    @timeline = current_user.timelines.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @timeline }
    end
  end
  
  def update
    @timeline = current_user.timelines.find(params[:id]).tap do |timeline|
      timeline.update!(timeline_params)
    end
    respond_to do |format|
      format.html { redirect_to timelines_path }
      format.json { render json: @timeline }
    end
  end
  
  def destroy
    timeline = current_user.timelines.destroy(params[:id])
    respond_to do |format|
      format.html { redirect_to timelines_path }
      format.json
    end
  end
  
  private
  def timeline_params
    params.require(:timeline).permit(:title, :content, :start_date, :end_date)
  end
end

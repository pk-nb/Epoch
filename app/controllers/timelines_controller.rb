class TimelinesController < ApplicationController
  include TimelineHelper
  before_action :require_login
  
  def index
    @timelines = owner.timelines
    
    respond_to do |format|
      format.html
      format.json { render json: @timelines }
    end
  end
  
  def show
    @timeline = owner.timelines.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @timeline }
    end
  end
  
  def children
    owner.all_children
  end
  
  def new
    @timeline = Timeline.new
    respond_to do |format|
      format.html
      format.json { render json: @timeline }
    end
  end
  
  def create
    @timeline = owner.timelines.create(timeline_params)
    respond_to do |format|
      format.html { redirect_to timelines_path }
      format.json { render json: @timeline }
    end
  end
  
  def edit
    @timeline = owner.timelines.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @timeline }
    end
  end
  
  def update
    @timeline = owner.timelines.find(params[:id]).tap do |timeline|
      timeline.update!(timeline_params)
    end
    respond_to do |format|
      format.html { redirect_to timelines_path }
      format.json { render json: @timeline }
    end
  end
  
  def destroy
    timeline = owner.timelines.destroy(params[:id])
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

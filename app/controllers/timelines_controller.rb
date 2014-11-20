class TimelinesController < ApplicationController
  before_action :require_login

  def index
    @timelines = current_user.timelines

    respond_to do |format|
      format.json { render json: @timelines }
    end
  end

  def show
    @timeline = current_user.timelines.find(params[:id])
    respond_to do |format|
      format.json { render json: @timeline }
    end
  end

  def children
    @children = current_user.timelines.find(params[:id]).all_children
    respond_to do |format|
      format.json { render json: @children }
    end
  end

  def list
    result = params[:ids].nil? ? {} : Timeline.list_by_ids(params[:ids], current_user)
    respond_to do |format|
        format.json {render json: result}
    end
  end

  def new
    @timeline = Timeline.new
    respond_to do |format|
      format.json { render json: @form_objs }
    end
  end

  def create
    @timeline = current_user.timelines.create(timeline_params)
    respond_to do |format|
      format.json do
       if @timeline.valid?
         render json: @timeline
       else
         render json: {errors: @timeline.errors.full_messages}, status: 422
       end
      end
    end
  end

  def edit
    @form_objs = current_user.timelines.find(params[:id])
    respond_to do |format|
      format.json { render json: @timeline }
    end
  end

  def update
    @timeline = current_user.timelines.find(params[:id]).tap do |timeline|
      timeline.update!(timeline_params)
    end
    respond_to do |format|
      format.json do
        if @timeline.valid?
          render json: @timeline
        else
          render json: {errors: @timeline.errors.full_messages}, status: 422
        end
      end
    end
  end

  def destroy
    current_user.timelines.destroy(params[:id])
    respond_to do |format|
      format.json { true }
    end
  end

  private
  def timeline_params
    params.require(:timeline).permit(:title, :content, :start_date, :end_date)
  end
end

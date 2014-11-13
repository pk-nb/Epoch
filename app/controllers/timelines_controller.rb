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
    @children = owner.timelines.find(params[:id]).all_children
    respond_to do |format|
      format.html
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
    @form_objs = [Timeline.new]
    @form_objs.insert(0, owner) if nested?
    respond_to do |format|
      format.html
      format.json { render json: @form_objs }
    end
  end

  def create
    @timeline = owner.timelines.create(timeline_params.merge(user_id: current_user.id))
    respond_to do |format|
      format.html { redirect_to timelines_path }
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
    @form_objs = owner.timelines.find(params[:id])
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

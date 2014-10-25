class RepositoryController < ApplicationController
  before_action :init

  def new
    @repositories = @client.repos
    @repositories.each do |r|
      r[:commits] = @client.commits(r)
    end
    @limit = @client.limit
    respond_to do |format|
      format.html
      format.json {render json: @repositories}
    end
  end

  def show
    @repo = @client.repo(params[:id], params[:repo])
    @repo[:commits] = @client.commits(@repo)
  end

  def create
    timeline.events.create(event_params.merge(user_id: current_user.id))
    respond_to do |format|
      format.html { redirect_to timeline_events_path }
      format.json {render json: @event}
    end
  end

  private
  def repository_params
    params.require(:event).permit(:title, :content, :start_date, :end_date)
  end

  def init
    @client = GithubUser.new
  end
end

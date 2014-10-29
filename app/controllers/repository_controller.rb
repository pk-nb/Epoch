class RepositoryController < ApplicationController
  before_action :init
  skip_before_filter :verify_authenticity_token #todo fix and don't have this

  def new
    repositories = @client.repos
    @repo_select = {}
    repositories.each do |r|
      @repo_select[r.full_name] = r.full_name
    end
    #@limit = @client.limit
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
    #@timeline = current_user.timeslines.create()

    repo_name = params[:other_repo_name].present? ? params[:other_repo_name] : params[:owned_repo_name]
    parts = repo_name.split('/')
    repo = @client.repo(parts.first, parts.last)
    repo[:commits] = @client.commits(repo)
    start = repo.commits.first.commit.author.date
    timeline = current_user.timelines.create(title: repo_name, content: "A log of activity from the #{repo_name} repository", start_date: start)
    timeline.save!
    #todo finish
    repo.commits.each do |c|
      e = timeline.events.create(title: "#{c.commit.author.date} commit", content: c.commit.message, start_date: c.commit.author.date, user_id: current_user.id, event_type: 'Repo')
      e.save!
    end

    respond_to do |format|
      format.html { redirect_to timeline_path(timeline) }
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

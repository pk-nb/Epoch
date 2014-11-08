class RepositoryController < ApplicationController
  before_action :init
  skip_before_filter :verify_authenticity_token #todo fix and don't have this

  def new
    repositories = @client.repos
    @repo_select = {}
    repositories.each do |r|
      @repo_select[r.full_name] = r.full_name
    end
    respond_to do |format|
      format.html
      format.json {render json: @repo_select}
    end
  end

  def show
    @repo = @client.repo(params[:id], params[:repo])
    @repo[:commits] = @client.commits(@repo)
  end

  # POST /create?name=someTimelineName&repos[]=first/repo&repos[]=second/repo...
  def create
    repo_names = params[:repos].nil? ? [] : params[:repos]
    # retrieve activity/commits/issues for each repository
    repos = []
    repo_names.each do |name|
      name_parts = name.split('/')
      if(name_parts.length != 2)
        return; # todo...error, what to do?
      end
      repo = @client.repo(name_parts.first, name_parts.last)
      unless repo.nil?
        repo[:commits] = @client.commits(repo)
        repo[:issues] = @client.issues(repo)
        repos.append(repo)
        dates = get_extreme_dates(repo)
        repo[:min_date] = dates[:min]
        repo[:max_date] = dates[:max]
      end
    end
    # Create a timeline to hold all of the repositories
    overall_min_date = repos.map{|r| r[:min_date]}.min
    overall_max_date = repos.map{|r| r[:max_date]}.max
    # todo in a perfect world, some of this creation logic should take place in models?
    master_timeline = current_user.timelines.create(title: params[:name], content: "A log of activity from the following repositories: #{repo_names.join(', ')}", start_date: overall_min_date, end_date: overall_max_date)
    # create timelines and events for each repository
    repos.each do |repo|
      # create a nested timeline
      timeline = master_timeline.timelines.create(title: repo.full_name, content: "A log of commits, issues, and pull requests from the #{repo.full_name} repository.",
                                                  start_date: repo[:min_date], end_date: repo[:max_date], user_id: current_user.id)
      # create events for commits
      repo.commits.each do |c|
        event = timeline.events.create(user_id: current_user.id, title: 'Commit', content: c.commit.message, start_date: c.commit.author.date, end_date: c.commit.author.date, event_type: 'Repo')
        event.repo_event = RepoEvent.create(event_id: event.id, repository: repo.full_name, author: c.commit.author.name,
                                            activity_type: 'Commit', html_url: c.html_url)
      end
      # create events for issues & pull requests
      repo.issues.each do |i|
        activity_type = i.pull_request.nil? ? 'Issue' : 'Pull Request'
        event = timeline.events.create(user_id: current_user.id, title: "#{activity_type} (#{i.state})", content: "#{i.title}: #{i.body}", start_date: i.created_at, end_date: i.closed_at, event_type: 'Repo')
        event.repo_event = RepoEvent.create(event_id: event.id, repository: repo.full_name, author: i.user.login,
                                            activity_type: activity_type, html_url: i.html_url)
      end
    end
    respond_to do |format|
      format.json {render json: master_timeline}
    end
  end

  private
  def init
    @client = GithubUser.new current_user
  end

  # Inspects the issues, commits, and pull requests of a repository
  # returns the earliest and latest dates found
  def get_extreme_dates(repo)
    dates = repo.commits.map{|c| c.commit.author.date} + repo.issues.map{|i| i.created_at}
    {min: dates.min, max: dates.max}
  end
end

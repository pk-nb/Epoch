class RepositoryController < ApplicationController
  before_action :init

  def new
    respond_to do |format|
      format.json {render json: Repositories.new(@client)}
    end
  end

  # POST /create?name=someTimelineName&repos[]=first/repo&repos[]=second/repo...
  def show
    @repo = @client.repo(params[:id], params[:repo])
    @repo[:commits] = @client.commits(@repo)
  end

  # todo IJH: Nathanael, do you want me to return some sort of direct indicator if one or more repository can't be loaded?
  def create
    success, result = try_import
    respond_to do |format|
      format.json do
        if success
          render json: result
        else
          render json: {errors: [result]}, status: 422
        end
      end
    end
  end

  private
  def init
    @client = GithubUser.new current_user
  end

  def try_import
    # check for repository names to be present
    if params[:repos].nil? || params[:repos] == []
      return false, 'Please select one or more repositories'
    end
    repo_names = params[:repos].nil? ? [] : params[:repos]
    # retrieve activity/commits/issues for each repository
    repos = []
    repo_names.each do |name|
      name_parts = name.split('/')
      if(name_parts.length != 2)
        return false, 'Please enter repository names in the form {owner}/{repoName}'
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
    # If more than one repository was specified, we need a name for the master timeline
    if params[:name].nil? || params[:name].empty?
      return false, 'Please enter a name for the timeline'
    end
    # Create a timeline to hold all of the repositories
    overall_min_date = repos.map{|r| r[:min_date]}.min
    overall_max_date = repos.map{|r| r[:max_date]}.max
    # todo in a perfect world, some of this creation logic should take place in models?
    # if there is more than 1 repository timeline to create, create a single timeline to hold the others
    master_timeline = repos.count > 1 ?
        current_user.timelines.create(title: params[:name], content: "A log of activity from the following repositories: #{repo_names.join(', ')}", start_date: overall_min_date, end_date: overall_max_date) :
        nil
    # create timelines and events for each repository
    repos.each do |repo|
      # create a nested timeline if the master timeline exists, otherwise create a top level timeline
      timeline = master_timeline.nil? ? current_user.timelines.create(title: params[:name], content: "A log of commits, issues, and pull requests from the #{repo.full_name} repository.",
                                                                      start_date: repo[:min_date], end_date: repo[:max_date]) :
          master_timeline.timelines.create(title: "Repository: #{repo.full_name}", content: "A log of commits, issues, and pull requests from the #{repo.full_name} repository.",
                                           start_date: repo[:min_date], end_date: repo[:max_date], user_id: current_user.id)
      # create events for commits
      repo.commits.each do |c|
        event = timeline.events.create(user_id: current_user.id, title: "Commit: #{c.commit.message[0..25]}", content: c.commit.message, start_date: c.commit.author.date, end_date: c.commit.author.date, event_type: 'Repo')
        event.repo_event = RepoEvent.create(event_id: event.id, repository: repo.full_name, author: c.commit.author.name,
                                            activity_type: 'Commit', html_url: c.html_url)
      end
      # create events for issues & pull requests
      repo.issues.each do |i|
        activity_type = i.pull_request.nil? ? 'Issue' : 'Pull Request'
        event = timeline.events.create(user_id: current_user.id, title: "#{activity_type} (#{i.state}): #{i.title[0..18]}", content: "#{i.title}: #{i.body}", start_date: i.created_at, end_date: i.closed_at, event_type: 'Repo')
        event.repo_event = RepoEvent.create(event_id: event.id, repository: repo.full_name, author: i.user.login,
                                            activity_type: activity_type, html_url: i.html_url)
      end
      # If we're only creating one repository, then we're done now. Set master timeline to the timeline we created so that it can be returned
      if master_timeline.nil?
        master_timeline = timeline
      end
    end
    return true, master_timeline
  end

  # Inspects the issues, commits, and pull requests of a repository
  # returns the earliest and latest dates found
  def get_extreme_dates(repo)
    dates = repo.commits.map{|c| c.commit.author.date} + repo.issues.map{|i| i.created_at}
    {min: dates.min, max: dates.max}
  end
end

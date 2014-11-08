class GithubUser
  def initialize(user)
    Octokit.connection_options[:ssl] = {:ca_file => File.join(Rails.root, 'cacert.pem')}
    # Instructing Octokit to automatically concatenate all pages. This may need to be revisited at a later date.
    Octokit.auto_paginate = true
    @client = Octokit::Client.new({client_id: ENV['GITHUB_ID'], client_secret: ENV['GITHUB_SECRET']})
    @user = @client.user user.github_account.login
  end

  def repos
    @user.rels[:repos].get.data
    #repo = repos[0]
    #commits = repo.rels[:commits].get.data
  end

  # retrieve the repository specified by the provided username and repository name
  def repo(user, repo)
    begin
      @client.repository("#{user}/#{repo}")
    rescue Octokit::NotFound
      nil
    end
  end

  # retrieve commits for the provided repository
  def commits(repo)
    repo.rels[:commits].get.data
  end

  # retrieve issues (which includes pull requests) for the provided repository
  def issues(repo)
    @client.issues(repo.full_name, {state: 'all'})
  end

  def limit
    @client.rate_limit
  end
end

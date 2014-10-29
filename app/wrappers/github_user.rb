class GithubUser
  def initialize
    Octokit.connection_options[:ssl] = {:ca_file => File.join(Rails.root, 'cacert.pem')}
    # Instructing Octokit to automatically concatenate all pages. This may need to be revisited at a later date.
    Octokit.auto_paginate = true
    @client = Octokit::Client.new({client_id: ENV['GITHUB_ID'], client_secret: ENV['GITHUB_SECRET']})
    @user = @client.user 'isaachermens'
  end

  def repos
    @user.rels[:repos].get.data
    #repo = repos[0]
    #commits = repo.rels[:commits].get.data
  end

  def repo(user, repo)
    @client.repository("#{user}/#{repo}")
  end

  def commits(repo)
    repo.rels[:commits].get.data
  end

  def limit
    @client.rate_limit
  end
end

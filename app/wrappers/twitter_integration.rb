class TwitterIntegration
  def friends_list
    result = []
    unless @twitter_account.nil?
      result.push([@twitter_account.name, @twitter_account.login])
      @client.friends(@twitter_account.uid.to_i, {count: 200}).each do |user|
        result.push([user.name, user.screen_name])
      end
    end
    result
  end

  def initialize(twitter_account)
    @twitter_account = twitter_account
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_ID']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      # use the user's access token/secret if they're logged in with Twitter
      config.access_token        = twitter_account.nil? ? ENV['TWITTER_TOKEN'] : twitter_account.oauth_token
      config.access_token_secret = twitter_account.nil? ? ENV['TWITTER_TOKEN_SECRET'] : twitter_account.oauth_secret
    end
  end

  # Pulled from https://github.com/sferik/twitter/blob/master/examples/AllTweets.md
  # used by get_all_{resource}
  def collect_with_max_id(collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
  end

  # Pulled from https://github.com/sferik/twitter/blob/master/examples/AllTweets.md
  def get_all_tweets(user)
    collect_with_max_id do |max_id|
      options = {count: 200, include_rts: true}
      options[:max_id] = max_id unless max_id.nil?
      @client.user_timeline(user, options)
    end
  end
end
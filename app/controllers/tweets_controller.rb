class TweetsController < ApplicationController
  before_action :init

  def new
    result = []
    unless current_user.twitter_account.nil?
      @client.friends(current_user.twitter_account.uid.to_i, {count: 200}).each do |user|
        result.push({name: user.name, id: user.id})
      end
    end
    respond_to do |format|
      format.json {render json: result}
    end
  end

  #create?timeline_name=Something&user_id=someTwitterID&start_date=SomeDate&end_date=SomeDate
  def create
    tweets = get_all_tweets(params.require(:user_id).to_i)
    # Filter by start date, if provided
    unless params[:start_date].nil?
      tweets = tweets.select{|t| t.created_at > params[:start_date]}
    end
    # Filter by start date, if provided
    unless params[:end_date].nil?
      tweets = tweets.select{|t| t.created_at < params[:end_date]}
    end

    # Only create a new timeline/events if there are more than 0 tweets, no reason to create empty timelines
    unless tweets.count == 0
      extreme_dates = get_extreme_dates(tweets)
      timeline = current_user.timelines.create(title: params.require(:timeline_name), content:
          "A Timeline of Tweets by #{@client.user(params[:user_id].to_i)}", start_date: extreme_dates[:min], end_date: extreme_dates[:max])
      tweets.each do |tweet|
        # todo use <br> tags instead of newlines? Remove altogether? Create seperate model?
        timeline.events.create(user_id: current_user.id, title: 'Tweet', content: "#{tweet.full_text}\nFavorited #{tweet.favorite_count} times\nRetweeted #{tweet.retweet_count} times",
                                       start_date: tweet.created_at, end_date: tweet.created_at, event_type: 'Tweet')
      end
    end
    respond_to do |format|
      format.json do
        if tweets.count == 0
          render json: {error: 'No tweets found for the specified user and filter dates'}, status: 422
        else
          render json: tweets
        end
      end
    end
  end

  private
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

  def get_all_friends(user)
    collect_with_max_id do |max_id|
      options = {count: 200}
      options[:max_id] = max_id unless max_id.nil?
      @client.friends(user, options)
    end
  end

  def init
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_ID']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      # use the user's access token/secret if they're logged in with Twitter
      config.access_token        = twitter_user.nil? ? ENV['TWITTER_TOKEN'] : twitter_user.oauth_token
      config.access_token_secret = twitter_user.nil? ? ENV['TWITTER_TOKEN_SECRET'] : twitter_user.oauth_secret
    end
  end

  def twitter_user
    current_user.twitter_account
  end

  # Inspects an array of tweets
  # returns the earliest and latest dates found
  def get_extreme_dates(tweets)
    dates = tweets.map{|t| t.created_at}
    {min: dates.min, max: dates.max}
  end
end

class TweetsController < ApplicationController

  def new
    result = (TwitterIntegration.new current_user.twitter_account).friends_list
    respond_to do |format|
      format.json {render json: result}
    end
  end

  #create?timeline_name=Something&user_id=someTwitterID&start_date=SomeDate&end_date=SomeDate
  def create
    twitter_int = TwitterIntegration.new current_user.twitter_account
    user_id = params.require(:user_id)
    if user_id == 0 then user_id = params.require(:alternate_user_id) end
    tweets = twitter_int.get_all_tweets(user_id)
    # Filter by start date, if provided
    unless params[:start_date].nil?
      tweets = tweets.select{|t| t.created_at > params[:start_date]}
    end
    # Filter by start date, if provided
    unless params[:end_date].nil?
      tweets = tweets.select{|t| t.created_at < params[:end_date]}
    end

    # Only create a new timeline/events if there are more than 0 tweets, no reason to create empty timelines
    timeline = nil
    unless tweets.count == 0
      extreme_dates = get_extreme_dates(tweets)
      timeline = current_user.timelines.create(title: params.require(:timeline_name), content:
          "A Timeline of Tweets by #{user_id}", start_date: extreme_dates[:min], end_date: extreme_dates[:max])
      tweets.each do |tweet|
        # todo use <br> tags instead of newlines? Remove altogether? Create separate model?
        timeline.events.create(user_id: current_user.id, title: 'Tweet', content: "#{tweet.full_text}\nFavorited #{tweet.favorite_count} times\nRetweeted #{tweet.retweet_count} times",
                                       start_date: tweet.created_at, end_date: tweet.created_at, event_type: 'Tweet')
      end
    end
    respond_to do |format|
      format.json do
        if tweets.count == 0
          render json: {errors: ['No tweets found for the specified user and filter dates']}, status: 422
        else
          render json: timeline
        end
      end
    end
  end

  private
  # Inspects an array of tweets
  # returns the earliest and latest dates found
  def get_extreme_dates(tweets)
    dates = tweets.map{|t| t.created_at}
    {min: dates.min, max: dates.max}
  end
end

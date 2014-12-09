class TweetsController < ApplicationController

  def new
    result = (TwitterIntegration.new current_user.twitter_account).friends_list
    respond_to do |format|
      format.json {render json: result}
    end
  end

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
  def try_import
    # verify timeline name provided
    if params[:timeline_name].nil? || params[:timeline_name].empty?
      return false, 'Please enter a timeline name'
    end
    account = current_user.nil? ? nil : current_user.twitter_account
    twitter_int = TwitterIntegration.new account
    user_id = params[:user_id]
    if user_id == 0 then user_id = params[:alternate_user_id] end
    # verify user provided
    if user_id == 0 || user_id.nil? || user_id.empty?
      return false, 'Please select or enter a Twitter user'
    end
    tweets = twitter_int.get_all_tweets(user_id)
    # Filter by start date, if provided
    filters = params[:filters]
    start_date = Date.parse("#{filters['start_date(1i)']}-#{filters['start_date(2i)']}-#{filters['start_date(3i)']}")
    end_date = Date.parse("#{filters['end_date(1i)']}-#{filters['end_date(2i)']}-#{filters['end_date(3i)']}")
    unless start_date.nil?
      tweets = tweets.select{|t| t.created_at >= start_date}
    end
    # Filter by start date, if provided
    unless end_date.nil?
      tweets = tweets.select{|t| t.created_at <= end_date}
    end

    # Only create a new timeline/events if there are more than 0 tweets, no reason to create empty timelines
    timeline = nil
    unless tweets.count == 0
      extreme_dates = get_extreme_dates(tweets)
      timeline = current_user.timelines.create(title: params[:timeline_name], content:
          "A Timeline of Tweets by #{user_id}", start_date: extreme_dates[:min], end_date: extreme_dates[:max])
      tweets.each do |tweet|
        # todo IJH: use <br> tags instead of newlines? Remove altogether? Create separate model?
        timeline.events.create(user_id: current_user.id, title: "#{tweet.full_text[0..30]}", content: "#{tweet.full_text}\nFavorited #{tweet.favorite_count} times\nRetweeted #{tweet.retweet_count} times",
                               start_date: tweet.created_at, end_date: tweet.created_at, event_type: 'Tweet')
      end
    else
      return false, 'No tweets found for the specified user and date range'
    end
    return true, timeline
  end

  # Inspects an array of tweets
  # returns the earliest and latest dates found
  def get_extreme_dates(tweets)
    dates = tweets.map{|t| t.created_at}
    {min: dates.min, max: dates.max}
  end
end

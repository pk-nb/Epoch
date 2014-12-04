class PagesController < ApplicationController
  def index
    @app_name = 'Epoch'
    @events = if current_user
                current_user.events.all.sort_by { |el| el.start_date}
              else
                Array.new
              end
  end


  def app
    @timelines = (params[:ids].nil? || current_user.nil?) ? [] : Timeline.list_by_ids(params[:ids]).as_json
    @user_timelines = current_user.nil? ? [] : current_user.timelines.map {|t| {title: t.title, id: t.id} }
    account = current_user.nil? ? nil : current_user.twitter_account
    @friends = (TwitterIntegration.new account).friends_list
    render layout: 'app'
  end
end

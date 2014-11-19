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
    @timelines = params[:ids].nil? ? [] : Timeline.list_by_ids(params[:ids], current_user).as_json
    @all_timelines_select = current_user.nil? ? [] : [{name: 'Select a timeline', value: 0}] + current_user.timelines.map{|t|{name: t.title, value: t.id}}
    render layout: 'app'
  end
end

class PagesController < ApplicationController
  def index
    @app_name = 'Epoch'
    @events = current_user.events.all.sort_by { |el| el.start_date}
  end
end
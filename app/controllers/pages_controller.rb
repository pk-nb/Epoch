class PagesController < ApplicationController
  def index
    @app_name = 'Epoch'
    @events = if current_user then
                current_user.events.all.sort_by { |el| el.start_date}
                else Array.new
              end
  end
end
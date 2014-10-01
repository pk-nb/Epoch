class Event < ActiveRecord::Base
  belongs_to :user
  attr_accessor :start_date_pretty, :end_date_pretty
  validates_presence_of :title, :content, :start_date

  def start_date_pretty
    start_date.strftime('%B %d, %Y')
  end

  def end_date_pretty
    end_date.strftime('%B %d, %Y')
  end
end

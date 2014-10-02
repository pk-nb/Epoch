class Timeline < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :events
  
  validates_datetime :end_date, on_or_after: :start_date, allow_nil: true
  validates_presence_of :title, :content, :start_date
  
  def start_date_pretty
    start_date.strftime('%B %d, %Y')
  end

  def end_date_pretty
    unless end_date.nil?
      end_date.strftime('%B %d, %Y')
    else
      "Ongoing"
    end
  end
end

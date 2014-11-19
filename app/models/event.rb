class Event < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :timelines
  has_one :repo_event


  attr_accessor :start_date_pretty, :end_date_pretty
  # Chicken or Egg bauk bauk bauk
  # For now, the rule that an event must belong to at least one timeline will be enforced
  #  by the UI. Enforcing it at the model level is made difficult by the join table
  #validates :timelines, length: { minimum: 1 }
  validates_presence_of :title, :content, :start_date, :user_id
  validates_datetime :end_date, on_or_after: :start_date, allow_nil: true
  validates_presence_of :event_type

  def start_date_pretty
    start_date.strftime('%B %d, %Y')
  end

  def end_date_pretty
    unless end_date.nil?
      end_date.strftime('%B %d, %Y')
    else
      'Ongoing'
    end
  end

  def as_json(options={})
    if event_type == 'Repo'
      options[:include] ||= [:repo_event]
    end
    super(options)
  end
end

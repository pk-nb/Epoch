class Event < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :timelines
  has_one :repo_event

  default_scope { order("start_date DESC") }

  attr_accessor :start_date_pretty, :end_date_pretty, :timeline_id
  # Chicken or Egg bauk bauk bauk
  # For now, the rule that an event must belong to at least one timeline will be enforced
  #  by the UI. Enforcing it at the model level is made difficult by the join table
  #validates :timelines, length: { minimum: 1 }
  validates_presence_of :title, :content, :start_date, :user_id
  validates_datetime :end_date, on_or_after: :start_date, allow_nil: true
  validates_presence_of :event_type

  def start_date_pretty
    start_date.strftime('%B %d, %Y at %I:%M%p')
  end

  def end_date_pretty
    unless end_date.nil?
      end_date.strftime('%B %d, %Y at %I:%M%p')
    else
      'Ongoing'
    end
  end

  def timeline_ids
    self.timelines.map{|el| el.id}
  end

  def as_json(options={})
    options[:methods] ||= [:timeline_ids, :start_date_pretty, :end_date_pretty]
    if event_type == 'Repo'
      options[:include] ||= [:repo_event]
    end
    super(options)
  end

  def self.create_initial_events(parent, user_id)
    base_date = Date.today
    parent.events.create(user_id: user_id, title: 'Click me!', content: 'Selecting an event and opening this panel allows you to view details about the event' , start_date: base_date, end_date: base_date, event_type: 'Epoch')
    parent.events.create(user_id: user_id, title: 'Then click on "Click me!" in the bottom left', content: '', start_date: base_date, end_date: base_date, event_type: 'Epoch')
    parent.events.create(user_id: user_id, title: 'Creating timelines',
                         content: 'Click the middle link in the top bar to create additional timelines or import information from Github or Twitter',
                         start_date: base_date, end_date: base_date, event_type: 'Epoch')
    parent.events.create(user_id: user_id, title: 'Viewing timelines',
                         content: 'Click the middle link in the top bar to choose which timelines you want to view',
                         start_date: base_date, end_date: base_date, event_type: 'Epoch')
    parent.events.create(user_id: user_id, title: 'Panning the timeline view',
                         content: 'To view additional events that are off the screen, simply drag left or right',
                         start_date: base_date, end_date: base_date, event_type: 'Epoch')
    parent.events.create(user_id: user_id, title: 'Creating events',
                         content: 'Without an event selected, click "+Event" in the bottom left corner to add events to a timeline',
                         start_date: base_date + 1.seconds, end_date: base_date + 1.seconds, event_type: 'Epoch')
    parent.events.create(user_id: user_id, title: 'Github/Twitter integration',
                         content: 'Before you can import tweets or Github repository timelines, you must link your account to Github/Twitter',
                         start_date: base_date + 1.seconds, end_date: base_date + 1.seconds, event_type: 'Epoch')
    parent.events.create(user_id: user_id, title: 'Linking accounts',
                         content: 'To link your Epoch account to external services, click your name in the top right and choose the service you wish to link to',
                         start_date: base_date + 1.seconds, end_date: base_date + 1.seconds, event_type: 'Epoch')
  end
end

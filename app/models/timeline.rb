class Timeline < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :events
  has_and_belongs_to_many :children,
                          class_name: "Timeline",
                          foreign_key: "parent_id",
                          association_foreign_key: "child_id"
  has_and_belongs_to_many :parents,
                          class_name: "Timeline",
                          foreign_key: "child_id",
                          association_foreign_key: "parent_id"

  alias_method :timelines, :children

  validates_datetime :end_date, on_or_after: :start_date, allow_nil: true
  validates_presence_of :title, :content, :start_date, :user_id

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

  def all_children
    (children + events).sort { |a, b| a.start_date <=> b.start_date }
  end

  def as_json(options={})
    #include all timeline and event children

    # UGLINESS AND BAD THINGS
    # options[:include] does NOT call as_json on assiociations
    # options[:methods] does however, so associations will be rendered using [:methods]
    #options[:include] ||= [:events]

    options[:methods] ||= [:timelines, :events]
    super(options)
  end


  def self.list_by_ids(ids)
    ids.map do |id|
      Timeline.find(id)
    end
  end
end

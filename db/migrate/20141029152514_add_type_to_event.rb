class AddTypeToEvent < ActiveRecord::Migration
  def change
    add_column :events, :type, :string

    add_column :repo_events, :event_id, :integer
    remove_column :repo_events, :date_created, :datetime
    remove_column :repo_events, :title, :string
  end
end

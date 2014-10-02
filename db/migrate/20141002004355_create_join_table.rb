class CreateJoinTable < ActiveRecord::Migration
  def change
    create_table :events_timelines, id: false do |t|
      t.belongs_to :event
      t.belongs_to :timeline
    end
  end
end

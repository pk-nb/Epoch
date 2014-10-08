class CreateTimelinesJoinTable < ActiveRecord::Migration
  def change
    create_table :timelines_timelines, id: false do |t|
      t.integer :parent_id
      t.integer :child_id
    end
  end
end

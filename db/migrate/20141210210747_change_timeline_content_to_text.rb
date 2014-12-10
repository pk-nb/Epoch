class ChangeTimelineContentToText < ActiveRecord::Migration
  def up
    change_column :timelines, :content, :text
  end

  def down
    change_column :timelines, :content, :string
  end
end

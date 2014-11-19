class ChangeContentToText < ActiveRecord::Migration
  def up
    change_column :events, :content, :text
  end

  def down
    change_column :events, :content, :string
  end
end

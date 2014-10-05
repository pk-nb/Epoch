class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timelines do |t|
      t.string :title
      t.string :content
      t.datetime :start_date
      t.datetime :end_date
      t.references :user

      t.foreign_key :users, dependent: :delete, name: 'timeline_user_foreign_key'
      t.timestamps
    end
  end
end

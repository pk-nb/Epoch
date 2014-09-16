class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :content
      t.datetime :start_date
      t.datetime :end_date
      # We may not want to cascade delete
      # May want to make this foreign key nullable if possible
      t.integer :user_id
      t.foreign_key :users, dependent: :delete, name: 'event_user_foreign_key'

      t.timestamps
    end
  end
end

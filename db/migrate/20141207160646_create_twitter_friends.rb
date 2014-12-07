class CreateTwitterFriends < ActiveRecord::Migration
  def change
    create_table :twitter_friends do |t|
      t.string :name
      t.string :login
      t.integer :user_id
      t.foreign_key :users, dependent: :delete, name: 'twitter_friends_user_foreign_key'

      t.timestamps
    end
  end
end

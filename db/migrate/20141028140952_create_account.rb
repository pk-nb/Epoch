class CreateAccount < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :oauth_token
      t.string :login
      t.datetime :oauth_expires_at

      t.string :email
      t.string :password_digest
      t.string :password_reset_token
      t.datetime :password_reset_sent_at
      t.string :picture

      t.datetime :date_added
      t.integer :user_id
      t.foreign_key :users, dependent: :delete

      t.timestamps
    end

    drop_table :profiles

    remove_column :users, :provider, :string
    remove_column :users, :uid, :string
    remove_column :users, :oauth_token, :string
    remove_column :users, :oauth_expires_at, :date_time
    remove_column :users, :name, :string
    remove_column :users, :picture, :string
  end
end

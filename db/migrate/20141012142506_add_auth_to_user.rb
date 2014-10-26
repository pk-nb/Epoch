class AddAuthToUser < ActiveRecord::Migration
  def change
    add_column :users, :email, :string, unique: true
    add_column :users, :password_digest, :string
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_sent_at, :datetime

    remove_column :profiles, :email
  end
end

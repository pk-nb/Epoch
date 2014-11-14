class AddSecretToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :oauth_secret, :string
  end
end

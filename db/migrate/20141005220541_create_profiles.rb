class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :favorite_cake

      t.integer :user_id
      t.foreign_key :users, dependent: :delete

      t.timestamps
    end
  end
end

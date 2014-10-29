class CreateRepoEvents < ActiveRecord::Migration
  def change
    create_table :repo_events do |t|
      t.string :repository
      t.datetime :date_created
      t.string :author
      t.string :activity_type
      t.string :html_url
      t.string :title

      t.timestamps
    end
  end
end

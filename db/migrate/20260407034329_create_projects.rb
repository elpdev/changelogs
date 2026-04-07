class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :github_url, null: false
      t.string :language
      t.integer :stars_count, default: 0
      t.integer :articles_count, default: 0
      t.datetime :last_synced_at

      t.timestamps
    end

    add_index :projects, :slug, unique: true
    add_index :projects, :github_url, unique: true
    add_index :projects, :language
    add_index :projects, :stars_count
  end
end

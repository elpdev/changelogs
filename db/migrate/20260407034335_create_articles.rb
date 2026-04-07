class CreateArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      t.references :project, null: false, foreign_key: true
      t.string :title, null: false
      t.string :slug, null: false
      t.text :summary
      t.text :content, null: false
      t.datetime :published_at

      t.timestamps
    end

    add_index :articles, :slug, unique: true
    add_index :articles, :published_at
    add_index :articles, [:project_id, :published_at]
  end
end

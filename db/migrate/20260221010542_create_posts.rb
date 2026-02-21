class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.references :category, null: false, foreign_key: true
      t.string :title
      t.string :slug
      t.boolean :published
      t.datetime :published_at
      t.text :meta_description
      t.integer :position

      t.timestamps
    end
    add_index :posts, :slug, unique: true
  end
end

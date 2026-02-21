class CreatePages < ActiveRecord::Migration[8.1]
  def change
    create_table :pages do |t|
      t.string :title
      t.string :slug
      t.text :meta_description
      t.boolean :published
      t.integer :position

      t.timestamps
    end
    add_index :pages, :slug, unique: true
  end
end

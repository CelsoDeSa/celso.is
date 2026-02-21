class CreateRedirects < ActiveRecord::Migration[8.1]
  def change
    create_table :redirects do |t|
      t.string :source
      t.string :destination
      t.boolean :active

      t.timestamps
    end
  end
end

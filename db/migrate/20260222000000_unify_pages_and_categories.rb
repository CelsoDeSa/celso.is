class UnifyPagesAndCategories < ActiveRecord::Migration[8.1]
  def up
    # Step 1: Add category fields to pages
    add_column :pages, :acts_as_category, :boolean, default: false, null: false
    add_column :pages, :category_description, :text

    # Step 2: Add page_id to posts (temporary, alongside category_id)
    add_reference :posts, :page, foreign_key: true

    # Step 3: Create category pages from hardcoded data
    # (Since Category model no longer exists, we recreate from known data)
    categories_data = [
      { name: "Exploring", description: "Deep dives into various topics", position: 1 },
      { name: "Experimenting", description: "N=1 trials and experiments", position: 2 },
      { name: "Learning", description: "Learning new skills", position: 3 },
      { name: "Thinking", description: "Essays and philosophy", position: 4 }
    ]

    categories_data.each do |cat_data|
      # Generate slug from name
      slug = cat_data[:name].parameterize

      page = Page.create!(
        title: cat_data[:name],
        slug: slug,
        acts_as_category: true,
        category_description: cat_data[:description],
        position: cat_data[:position],
        published: true
      )

      # Try to find old category by name and update posts
      # This uses raw SQL to avoid model dependency
      old_category_id = execute("SELECT id FROM categories WHERE name = '#{cat_data[:name]}'").first
      if old_category_id
        execute("UPDATE posts SET page_id = #{page.id} WHERE category_id = #{old_category_id['id']}")
      end
    end

    # Step 4: Remove category_id from posts
    remove_reference :posts, :category, foreign_key: true

    # Step 5: Drop categories table
    drop_table :categories if table_exists?(:categories)
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "This migration is one-way. Restore from backup if needed."
  end
end

require "test_helper"

class DataMigrationTest < ActiveSupport::TestCase
  test "category pages have acts_as_category flag set" do
    exploring = pages(:exploring)
    learning = pages(:learning)

    assert exploring.acts_as_category?
    assert learning.acts_as_category?
    assert exploring.category_description.present?
  end

  test "static pages do not have acts_as_category flag" do
    a_dev = pages(:a_dev)
    a_mindhacker = pages(:a_mindhacker)

    assert_not a_dev.acts_as_category?
    assert_not a_mindhacker.acts_as_category?
  end

  test "posts belong to category pages" do
    post_one = posts(:one)
    post_two = posts(:two)

    assert post_one.page.acts_as_category?
    assert post_two.page.acts_as_category?
  end

  test "slugs are preserved and unique" do
    slugs = Page.all.map(&:slug)
    assert_equal slugs.uniq.length, slugs.length, "All page slugs should be unique"
  end

  test "category pages can have many posts" do
    exploring = pages(:exploring)
    assert_respond_to exploring, :posts

    # Add another post to exploring
    exploring.posts.create!(
      title: "Another Post",
      slug: "another-post",
      published: true,
      published_at: Time.current
    )

    assert_equal 2, exploring.posts.count
  end

  test "static pages have content association" do
    a_dev = pages(:a_dev)
    assert a_dev.content.is_a?(ActionText::RichText)
  end

  test "category pages can be converted to static" do
    exploring = pages(:exploring)

    # Convert to static
    exploring.update!(acts_as_category: false, content: "New static content")

    assert_not exploring.reload.acts_as_category?
    assert exploring.content.present?
  end

  test "static pages can be converted to categories" do
    a_dev = pages(:a_dev)
    initial_post_count = a_dev.posts.count

    # Convert to category
    a_dev.update!(
      acts_as_category: true,
      category_description: "Now a category"
    )

    assert a_dev.reload.acts_as_category?
    assert a_dev.category_description.present?
    assert_equal initial_post_count, a_dev.posts.count
  end
end

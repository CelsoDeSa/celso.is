require "test_helper"

class PageTest < ActiveSupport::TestCase
  setup do
    @exploring = pages(:exploring)
    @a_dev = pages(:a_dev)
  end

  test "page can act as category" do
    assert @exploring.acts_as_category?
    assert @exploring.category?
  end

  test "page can be static" do
    assert_not @a_dev.acts_as_category?
    assert @a_dev.static_page?
  end

  test "category pages can have posts" do
    assert_respond_to @exploring, :posts
    assert_equal 1, @exploring.posts.count
  end

  test "static pages can have content" do
    assert_respond_to @a_dev, :content
    # Note: content is Action Text, so it exists but may be empty in fixtures
    assert @a_dev.content.is_a?(ActionText::RichText)
  end

  test "page requires a title" do
    page = Page.new(slug: "test")
    assert_not page.valid?
    assert_includes page.errors[:title], "can't be blank"
  end

  test "page generates slug from title" do
    page = Page.create!(
      title: "My New Page",
      acts_as_category: false,
      published: true
    )
    assert_equal "my-new-page", page.slug
  end

  test "page generates unique slug" do
    # friendly_id ensures uniqueness by appending suffix if needed
    page = Page.create!(
      title: @exploring.title,  # Same title as existing page
      acts_as_category: false,
      published: true
    )
    # Should create with a unique slug
    assert_not_equal @exploring.slug, page.slug
    assert_match /^exploring(-[a-f0-9-]+)?$/, page.slug
  end

  test "published scope returns only published pages" do
    Page.create!(
      title: "Draft Page",
      acts_as_category: false,
      published: false
    )
    assert Page.published.count < Page.count
  end

  test "categories scope returns only category pages" do
    categories = Page.categories
    assert categories.all?(&:acts_as_category?)
    assert_includes categories.to_a, @exploring
    assert_not_includes categories.to_a, @a_dev
  end

  test "static_pages scope returns only static pages" do
    static = Page.static_pages
    assert static.none?(&:acts_as_category?)
    assert_includes static.to_a, @a_dev
    assert_not_includes static.to_a, @exploring
  end

  test "ordered scope sorts by position" do
    pages = Page.ordered.to_a
    assert pages.each_cons(2).all? { |a, b| a.position <= b.position }
  end

  test "category pages have description" do
    assert @exploring.category_description.present?
  end

  test "friendly_id finds page by slug" do
    found = Page.friendly.find(@exploring.slug)
    assert_equal @exploring, found
  end

  test "should_generate_new_friendly_id? returns true when title changes" do
    old_slug = @a_dev.slug
    @a_dev.title = "New Title #{Time.current.to_i}"
    assert @a_dev.should_generate_new_friendly_id?
    @a_dev.save!
    assert_not_equal old_slug, @a_dev.slug
  end

  test "destroying category page destroys associated posts" do
    post_count = @exploring.posts.count
    assert post_count > 0

    @exploring.destroy
    assert_equal 0, Post.where(page_id: @exploring.id).count
  end
end

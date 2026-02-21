require "test_helper"

class PostTest < ActiveSupport::TestCase
  setup do
    @exploring = pages(:exploring)
    @post = posts(:one)
  end

  test "post belongs to a page" do
    assert_equal @exploring, @post.page
  end

  test "post requires a title" do
    post = Post.new(page: @exploring, slug: "test")
    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
  end

  test "post requires a page" do
    post = Post.new(title: "Test Post", slug: "test")
    assert_not post.valid?
    assert_includes post.errors[:page], "must exist"
  end

  test "post generates slug from title" do
    post = Post.create!(
      title: "My New Post",
      page: @exploring,
      published: true,
      published_at: Time.current
    )
    assert_equal "my-new-post", post.slug
  end

  test "post generates unique slug" do
    # friendly_id ensures uniqueness by appending numbers if needed
    post = Post.create!(
      title: @post.title,  # Same title as existing post
      page: @exploring,
      published: true,
      published_at: Time.current
    )
    # Should create with a unique slug
    assert_not_equal @post.slug, post.slug
  end

  test "published scope returns only published posts" do
    published_count = Post.published.count
    Post.create!(
      title: "Draft Post",
      page: @exploring,
      published: false,
      published_at: Time.current
    )
    assert_equal published_count, Post.published.count
  end

  test "published? returns true for published posts" do
    assert @post.published?

    @post.update!(published: false)
    assert_not @post.published?
  end

  test "published? returns false for future dated posts" do
    @post.update!(published: true, published_at: 1.day.from_now)
    assert_not @post.published?
  end

  test "ordered scope sorts by position then published_at" do
    posts = Post.ordered.to_a
    assert posts.first.position <= posts.last.position ||
           posts.first.published_at >= posts.last.published_at
  end

  test "post has rich text content" do
    assert_respond_to @post, :content
    assert @post.content.is_a?(ActionText::RichText)
  end

  test "friendly_id finds post by slug" do
    found = Post.friendly.find(@post.slug)
    assert_equal @post, found
  end

  test "should_generate_new_friendly_id? returns true when title changes" do
    old_slug = @post.slug
    @post.title = "New Title #{Time.current.to_i}"
    assert @post.should_generate_new_friendly_id?
    @post.save!
    assert_not_equal old_slug, @post.slug
  end
end

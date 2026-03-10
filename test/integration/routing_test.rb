require "test_helper"

class RoutingTest < ActionDispatch::IntegrationTest
  setup do
    @exploring = pages(:exploring)
    @learning = pages(:learning)
    @a_dev = pages(:a_dev)
    @post_one = posts(:one)
    @post_two = posts(:two)
  end

  test "homepage renders successfully" do
    get root_path
    assert_redirected_to resume_path
  end

  test "category page renders list of posts" do
    get page_path(@exploring)
    assert_response :success
    assert_select "h1", "Exploring"
    assert_select ".grid article", count: @exploring.posts.count
  end

  test "static page renders content" do
    get page_path(@a_dev)
    assert_response :success
    # The /a-dev route now points directly to the resume action instead of pages#show
    assert_select "h1", "Celso is a Dev"
  end

  test "individual post under category renders" do
    get page_post_path(@exploring, @post_one)
    assert_response :success
    assert_select "h1", @post_one.title
    assert_select "header a", @exploring.title
  end

  test "non-existent page redirects with error" do
    get "/non-existent-page"
    assert_redirected_to root_path
    assert_not_nil flash[:alert]
    assert_match /Page not found/, flash[:alert]
  end

  test "category pages don't show 'Category not found' error" do
    get page_path(@exploring)
    assert_response :success
    assert_no_match /Category not found/i, response.body
  end

  test "static pages don't conflict with categories" do
    # This verifies /a-dev shows the page, not trying to find a category
    get page_path(@a_dev)
    assert_response :success
    assert_select "h1", "Celso is a Dev"
    assert_no_match /Category not found/i, response.body
  end

  test "admin dashboard is accessible" do
    get admin_root_path, headers: {
      "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("admin", "changeme123")
    }
    assert_response :success
    assert_select "h1", "Dashboard"
  end

  test "admin posts index lists all posts" do
    get admin_posts_path, headers: {
      "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("admin", "changeme123")
    }
    assert_response :success
    assert_select "table tbody tr", count: Post.count
  end

  test "admin pages index lists all pages" do
    get admin_pages_path, headers: {
      "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("admin", "changeme123")
    }
    assert_response :success
    assert_select "table tbody tr", count: Page.count
  end

  test "active redirect redirects to internal destination" do
    get "/contact"
    assert_redirected_to "/a-dev"
    assert_equal 302, status
  end

  test "active redirect redirects to external destination" do
    get "/github"
    assert_redirected_to "https://github.com/celso"
    assert_equal 302, status
  end

  test "inactive redirect does not redirect and falls back to page not found" do
    get "/old-page"
    # Should not redirect to /a-dev (the destination of inactive_redirect)
    assert_redirected_to root_path
    assert_not_nil flash[:alert]
    assert_match /Page not found/, flash[:alert]
  end

  test "redirect takes precedence over page lookup" do
    # /contact is a redirect, not a page
    get "/contact"
    assert_redirected_to "/a-dev"
  end

  test "admin redirects index lists all redirects" do
    get admin_redirects_path, headers: {
      "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("admin", "changeme123")
    }
    assert_response :success
    assert_select "table tbody tr", count: Redirect.count
  end
end

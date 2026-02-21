module Admin
  class DashboardController < Admin::BaseController
    def index
      @posts_count = Post.count
      @pages_count = Page.count
      @categories_count = Category.count
      @recent_posts = Post.ordered.limit(5)
    end
  end
end

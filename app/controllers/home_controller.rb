class HomeController < ApplicationController
  def index
    @featured_pages = Page.published.ordered.limit(3)
    @recent_posts = Post.published.ordered.limit(6)
  end
end

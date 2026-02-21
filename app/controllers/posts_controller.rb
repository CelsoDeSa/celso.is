class PostsController < ApplicationController
  def show
    @page = Page.friendly.find(params[:page_id])
    @post = @page.posts.published.friendly.find(params[:id])
    @meta_description = @post.meta_description if @post.meta_description.present?
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Post not found"
  end
end

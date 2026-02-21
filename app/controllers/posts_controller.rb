class PostsController < ApplicationController
  def show
    @category = Category.friendly.find(params[:category_id])
    @post = @category.posts.published.friendly.find(params[:id])
    @meta_description = @post.meta_description if @post.meta_description.present?
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Post not found"
  end
end

class CategoriesController < ApplicationController
  def show
    @category = Category.friendly.find(params[:category_id])
    @posts = @category.posts.published.ordered
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Category not found"
  end
end

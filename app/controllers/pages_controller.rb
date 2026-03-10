class PagesController < ApplicationController
  def show
    # Check for redirects first
    redirect = Redirect.active.find_by(source: params[:id])
    if redirect
      redirect_to redirect.destination, status: :found, allow_other_host: true
      return
    end

    @page = Page.published.friendly.find(params[:id])
    @meta_description = @page.meta_description if @page.meta_description.present?

    if @page.category?
      @posts = @page.posts.published.ordered
      render "categories/show"
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Page not found"
  end
end

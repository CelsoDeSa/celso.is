class PagesController < ApplicationController
  def show
    @page = Page.published.friendly.find(params[:id])
    @meta_description = @page.meta_description if @page.meta_description.present?
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Page not found"
  end
end

class RedirectsController < ApplicationController
  def show
    redirect = Redirect.active.find_by(source: params[:source])

    if redirect
      redirect_to redirect.destination, status: :found, allow_other_host: true
    else
      # If no redirect found, try to find it as a page
      begin
        @page = Page.published.friendly.find(params[:source])
        render "pages/show"
      rescue ActiveRecord::RecordNotFound
        redirect_to root_path, alert: "Page not found"
      end
    end
  end
end

module Admin
  class RedirectsController < Admin::BaseController
    before_action :set_redirect, only: [ :show, :edit, :update, :destroy ]

    def index
      @redirects = Redirect.all
    end

    def show
    end

    def new
      @redirect = Redirect.new
      @redirect.active = true
    end

    def create
      @redirect = Redirect.new(redirect_params)

      if @redirect.save
        redirect_to admin_redirects_path, notice: "Redirect was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @redirect.update(redirect_params)
        redirect_to admin_redirects_path, notice: "Redirect was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @redirect.destroy
      redirect_to admin_redirects_path, notice: "Redirect was successfully deleted."
    end

    private

    def set_redirect
      @redirect = Redirect.find(params[:id])
    end

    def redirect_params
      params.require(:redirect).permit(:source, :destination, :active)
    end
  end
end

module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_action :authenticate

    private

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV["ADMIN_USERNAME"] && password == ENV["ADMIN_PASSWORD"]
      end
    end
  end
end

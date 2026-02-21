module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_action :authenticate

    private

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        # For now, use simple credentials
        # Change these after first login!
        username == "admin" && password == "changeme123"
      end
    end
  end
end

module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_action :authenticate

    private

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV.fetch("ADMIN_USERNAME", "admin") &&
          password == ENV.fetch("ADMIN_PASSWORD", "changeme123")
      end
    end
  end
end

module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_action :authenticate

    private

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == admin_username && password == admin_password
      end
    end

    def admin_username
      Rails.application.credentials.admin&.dig(:username) || "admin"
    end

    def admin_password
      Rails.application.credentials.admin&.dig(:password) || "changeme123"
    end
  end
end

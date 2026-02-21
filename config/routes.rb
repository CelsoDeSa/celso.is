Rails.application.routes.draw do
  # Health check for monitoring
  get "up" => "rails/health#show", as: :rails_health_check

  # Admin routes
  namespace :admin do
    root "dashboard#index"
    resources :posts
    resources :pages
    resources :redirects
  end

  # Public routes
  root "home#index"

  # Posts under their parent page
  get "/:page_id/:id", to: "posts#show", as: :page_post

  # Everything else is a page (static or category)
  get "/:id", to: "pages#show", as: :page
end

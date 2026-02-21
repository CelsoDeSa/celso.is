Rails.application.routes.draw do
  # Health check for monitoring
  get "up" => "rails/health#show", as: :rails_health_check

  # Admin routes
  namespace :admin do
    root "dashboard#index"
    resources :categories
    resources :posts
    resources :pages
    resources :redirects
  end

  # Smart redirects (check before other routes)
  get "/:source", to: "redirects#show", constraints: { source: /[a-z0-9\-]+/ }, as: :smart_redirect

  # Public routes
  root "home#index"

  # Category posts (e.g., /exploring/sleep)
  get "/:category_id/:id", to: "posts#show", as: :category_post
  get "/:category_id", to: "categories#show", as: :category

  # Static pages (e.g., /a-dev)
  get "/:id", to: "pages#show", as: :page
end

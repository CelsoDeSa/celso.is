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

  # Public routes
  root "home#index"

  # Category routes (MUST come before redirects and pages to avoid being caught by wildcard routes)
  get "/:category_id/:id", to: "posts#show", as: :category_post
  get "/:category_id", to: "categories#show", as: :category

  # Static pages (e.g., /a-dev)
  # Exclude common category names from being caught by pages
  get "/:id", to: "pages#show", as: :page

  # Smart redirects - LAST resort for unmatched routes
  # This catches any remaining single-segment URLs and checks for redirects
  get "/:source", to: "redirects#show", constraints: { source: /[a-z0-9\-]+/ }, as: :smart_redirect
end

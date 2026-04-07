Rails.application.routes.draw do
  constraints AdminConstraint.new do
    mount Quarterdeck::Engine => "/quarterdeck"
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  resources :notifications, only: [:index, :update] do
    collection do
      post :mark_all_read
    end
  end

  draw :madmin
  # API routes
  namespace :api do
    namespace :v1 do
      post "auth/token", to: "auth#create"
      resources :projects
      resources :articles
    end
  end

  # API keys management
  resources :api_keys, only: [:index, :new, :create, :destroy]

  resource :profile, only: [:show, :edit, :update]
  resource :registration, only: [:new, :create]
  resource :session
  resources :passwords, param: :token
  get "/home", to: "home#show", as: :home

  # Public content pages
  resources :projects, only: [:index, :show], param: :slug
  resources :articles, only: [:show], param: :slug

  root "landing#show"

  get "up" => "rails/health#show", :as => :rails_health_check
end

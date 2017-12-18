Rails.application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root to: "home#index", as: :user_root

  resources :relations, only: [:create, :destroy] do
    collection do
      get "refresh"
      post "refresh_list"
    end
  end

  get "@:id" => "users#show", as: :user

  resources :projects, path: :diy

  resources :publications, only: [:create, :destroy] do
    new do
      get ':type', action: :new, as: ""
    end
    collection do
      post "trix_attachment"
    end
    member do
      get '(/:index)', action: :show, as: ""
    end
  end

  devise_for :users, path:"account", controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :notifications do
    collection do
      post :clean
    end
  end

  resources :comments, only: [:destroy]
  resources :statuses, only: [:index, :show, :destroy] do
    resources :comments, only: [:new, :create]
  end

  ##
  # 管理
  authenticate :user, -> (user) { user.admin? } do
    scope :admin do
      resources :statistics, only: [:index]
      mount PgHero::Engine, at: "pghero"
    end
  end
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # 会匹配所有剩下的 url，并 render error，它之后的 route 不会匹配
  # match '*path', to: 'home#error_404', via: :all

end

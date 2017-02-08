Rails.application.routes.draw do
  root to: "home#index", as: :user_root
  scope :admin do
    resources :statistics, only: [:index]
  end
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :relations, only: [:create, :destroy] do
    collection do
      get "refresh"
    end
  end

  resources :projects, path: :diy

  scope :i do
    resources :users, path: '', only: [:show] do
    end
  end

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
  mount RuCaptcha::Engine => "/rucaptcha"

  resources :comments, only: [:destroy]
  resources :statuses, only: [:index, :show, :destroy] do
    resources :comments, only: [:new, :create]
  end


  # 会匹配所有剩下的 url，并 render error，它之后的 route 不会匹配
  match '*path', to: 'home#error_404', via: :all

end

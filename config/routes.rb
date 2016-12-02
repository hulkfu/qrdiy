Rails.application.routes.draw do
  root to: "statuses#index"
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get 'd/:id', to: "projects#show"

  resources :diy, controller: :projects, as: :projects
  resources :i, controller: :user_profiles, as: :user_profiles

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  mount RuCaptcha::Engine => "/rucaptcha"

  resources :statuses




  # 会匹配所有剩下的 url，并 render error，它之后的 route 不会匹配
  match '*path', to: 'home#error_404', via: :all

  # 之前二维码的，先不用
  resources :codes do
    member do
      get :download
    end
    collection do
      get :qr
    end
    resources :prints
  end

  post "text", to: "home#text"
  get "text(/:qr_id)", to: "home#text"
end

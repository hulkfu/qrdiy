Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :projects
  resources :user_profiles
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  mount RuCaptcha::Engine => "/rucaptcha"

  resources :codes do
    member do
      get :download
    end
    collection do
      get :qr
    end
    resources :prints
  end

  resources :yunmas, only: [:index]

  post "text", to: "home#text"
  get "text(/:qr_id)", to: "home#text"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#text"


  # error
  match '*path', to: 'home#error_404', via: :all
end

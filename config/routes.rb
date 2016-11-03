Rails.application.routes.draw do
  resources :codes do
    member do
      get :download
    end
    collection do
      get :qr
    end
    resources :prints
  end

  resources :yuns, only: [:index]

  post "text", to: "home#text"
  get "text(/:qr_id)", to: "home#text"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#text"
end

Rails.application.routes.draw do
  resources :codes do
    collection do
      get :qr
    end
    resources :prints
  end

  post "text", to: "home#text"
  get "text", to: "home#text"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#text"
end

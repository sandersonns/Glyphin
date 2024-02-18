Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # Add custom member routes for the Tokens resources. 
  # `redeem` is a POST request as it modifies data (redeeming the token).
  # `validate_token` is a GET request as it's only fetching and verifying data without changing anything.
  resources :tokens, only: [:index, :new, :create, :show, :destroy] do
    member do
      post :redeem        # For redeeming the token.
      get :validate_token # For validating the token without redeeming.
    end
  end
  resources :users
  resources :comments, only: [:new, :create, :edit, :destroy]
  resources :glyphs
  resources :messages, only: [:new, :create, :edit, :destroy]
  resources :what3words

end

Cubbyhole::Application.routes.draw do

  use_doorkeeper
  devise_for :users

  namespace :api, constraints: { format: 'json' } do
    resources :folders
  end

  root to: 'home#index'
end

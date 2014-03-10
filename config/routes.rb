Cubbyhole::Application.routes.draw do

  use_doorkeeper
  devise_for :users

  namespace :api, constraints: { format: 'json' } do
    resources :folders, except: [:index, :new, :edit] do
      member do
        get :items, to: 'folders#index'
        post :copy
      end
    end
  end
  resources :plans
  root to: 'home#index'
end

Cubbyhole::Application.routes.draw do

  use_doorkeeper
  devise_for :users

  namespace :api, constraints: { format: 'json' } do
    resources :folders, except: [:index, :new, :edit] do
      get 'items', to: 'folders#index', on: :member
    end
  end

  root to: 'home#index'
end

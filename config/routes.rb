Cubbyhole::Application.routes.draw do
  ActiveAdmin.routes(self)
  use_doorkeeper
  devise_for :users

  namespace :api, constraints: { format: 'json' } do
    resources :folders, except: [:index, :new, :edit] do
      member do
        get :items, to: 'folders#index'
        post :copy
      end
    end
    resources :assets, except: [:new, :edit], path: :files do
      member do
        get :content
        post :copy
      end
    end
  end
  resources :plans
  resources :payments, only: [:new, :create]

  match '/app' => 'main#index', via: :get
  root to: 'home#index'
end

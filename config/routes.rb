require 'sidekiq/web'

Cubbyhole::Application.routes.draw do
  ActiveAdmin.routes(self)

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  use_doorkeeper

  devise_for :users,
    path: '',
    path_names: {
      sign_in: 'login',
      sign_up: 'register'
    },
    controllers: {
      registrations: :registrations
    }

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
    resources :folders
    resources :assets do
      member do
        get :download
      end
    end
    resources :payments, only: [:new, :create]

    root to: 'home#index'
    match '/features', to: 'home#features', via: :get
    match '/prices', to: 'home#prices', via: :get
end

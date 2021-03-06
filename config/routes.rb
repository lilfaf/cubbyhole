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

    resources :charts
    resources :plans
    resources :folders
    resources :assets do
      member do
        get :download
        get :shared
      end
    end
    resources :payments, only: [:new, :create]
    resources :share_links

    root to: 'home#index'

end

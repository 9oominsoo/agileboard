Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount ActionCable.server => '/cable'
  devise_for :users
  root 'home#index'
  get 'home/index'

  resources :conversations, only: [:create] do
    member do
        post :close
    end
  resources :messages, only: [:create]
end

  resources :projects do
    collection do
      get :mypage
    end
    member do
      get :recovery
      get :project_posts
    end
  end
  resources :posts do
    collection do
      get :search
    end
  end
  resources :comments
  resources :messages
  resources :functions do
    collection do
      put :update_state
    end
  end

end

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # MEMO: 色々試したい場合はこのページを使う
  # get "/sample" => "sample#index", as: :sample

  get "/" => redirect("/users/sign_in")

  namespace :mypage do
    get "/" => "mypage#index"
    resources :groups, only: [:new, :create, :show, :edit, :update, :destroy] do
      member do
        get 'confirm_destroy' # 削除前確認画面
      end
      resources :group_members, only: [:index] do
        member do
          get 'add'
        end
      end
      resources :albums, only: [:new, :create, :show, :edit, :update, :destroy] do
        member do
          get 'confirm_destroy'  # 削除前確認画面
        end
        resources :media_items, only: [:new, :show]
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :albums do
        resources :media_items, only: [:create, :destroy] do
          resources :media_item_comments, only: [:create, :destroy]
        end
      end
    end
  end
end

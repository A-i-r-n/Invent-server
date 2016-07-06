Rails.application.routes.draw do
  root "products#index"

  namespace :api do
    resources :products,only:[:index]
    resources :vendors,only:[:index]
  end

  namespace :seller do
    get 'attachment/:id/:filename.:extension' => 'attachments#show'

    resources :customers do
      post :search, on: :collection
      resources :addresses
    end

    resources :product_categories do
      resources :localisations, controller: 'product_category_localisations'
    end
    resources :products do
      resources :variants
      resources :localisations, controller: 'product_localisations'
      collection do
        get :import
        post :import
      end
    end
    resources :orders do
      collection do
        post :search
      end
      member do
        post :accept
        post :reject
        post :ship
        get :despatch_note
      end
      resources :payments, only: [:create, :destroy] do
        match :refund, on: :member, via: [:get, :post]
      end
    end
    resources :stock_level_adjustments, only: [:index, :create]
    resources :delivery_services do
      resources :delivery_service_prices
    end
    resources :tax_rates
    resources :users
    resources :countries
    resources :attachments, only: :destroy

    get 'settings' => 'settings#edit'
    post 'settings' => 'settings#update'

    resources :accounts do
      collection do
        get 'login'
        post 'login'
        get 'signup'
        post 'signup'
        get 'logout'
      end
    end

    get 'login/reset' => 'password_resets#new'
    post 'login/reset' => 'password_resets#create'

    root 'dashboard#index'
  end

  namespace :admin do
    get 'attachment/:id/:filename.:extension' => 'attachments#show'

    resources :customers do
      post :search, on: :collection
      resources :addresses
    end

    resources :product_categories do
      resources :localisations, controller: 'product_category_localisations'
    end
    resources :products do
      resources :variants
      resources :localisations, controller: 'product_localisations'
      collection do
        get :import
        post :import
      end
    end
    resources :orders do
      collection do
        post :search
      end
      member do
        post :accept
        post :reject
        post :ship
        get :despatch_note
      end
      resources :payments, only: [:create, :destroy] do
        match :refund, on: :member, via: [:get, :post]
      end
    end
    resources :stock_level_adjustments, only: [:index, :create]
    resources :delivery_services do
      resources :delivery_service_prices
    end
    resources :tax_rates
    resources :users
    resources :countries
    resources :attachments, only: :destroy

    get 'settings' => 'settings#edit'
    post 'settings' => 'settings#update'

    resources :accounts do
      collection do
        get 'login'
        post 'login'
        get 'signup'
        post 'signup'
        get 'logout'
      end
    end

    get 'login/reset' => 'password_resets#new'
    post 'login/reset' => 'password_resets#create'

    root 'dashboard#index'
  end
end

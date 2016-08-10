Rails.application.routes.draw do
  root "products#index"

  # match 'api/captcha' => 'easy_captcha/captcha#captcha', :via => :get

  get 'api/captcha',to: 'easy_captcha/captcha#captcha'

  namespace :api do
    resources :products,only:[:index,:show] do
      collection do
        get ':id/images',action: 'images'
        get ':id/variants',action: 'variants'
        get ':id/attributes',action: 'attributes'
        get ':id/detail',action: 'detail'
      end
      member do
        post 'carriage_price'
      end
    end

    match 'vendor/settle_in', to: 'vendors#settle_in', via: [:get,:post]

    resources :vendors,only:[:index] do
      resources :product_categories
    end

    resources :accounts,path: 'account' do
      collection do
        post 'login'
        match 'info',via: [:get,:post]
      end
    end
    resources :product_categories do
      resources :products
    end
    resources :carts
    resources :collections
    resources :banners,only:[:index]
    resources :visitor_logs,only:[:index]

    get "areas/:name/streets",to: "areas#streets"
    resources :areas,only: [:index]
    resources :users,path:'user' do
      collection do
        get 'addresses'
        get 'address'
      end
    end

    resources :orders ,only:[:index,:create]

    resources :payments,only:[:create]

    match "payment/secure_pay/:method", to: "payments#secure_pay", via: [:get, :post]

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

    resources :carriage_templates do
      resources :carriage_template_prices
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

    resources :vendors do
      member do
        post :accept
        post :reject
      end
    end

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

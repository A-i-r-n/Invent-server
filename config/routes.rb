Rails.application.routes.draw do


  namespace :api do
  get 'cosmetic/index'
  end

  root "products#index"

  # match 'api/captcha' => 'easy_captcha/captcha#captcha', :via => :get

  get 'api/captcha',to: 'easy_captcha/captcha#captcha'

  namespace :api do
    resources :products,only:[:index,:show,:create] do
      member do
        post 'carriage_price'
        get 'images'
        get 'variants'
        get 'attributes'
        get 'detail'
        get 'user'
        get 'share'
      end
    end

    match 'vendor/settle_in', to: 'vendors#settle_in', via: [:get,:post]

    resources :vendors,only:[:index,:show] do
      member do
        get 'share'
      end
      resources :product_categories
    end

    resources :accounts,path: 'account' do
      collection do
        post 'login'
        match 'info',via: [:get,:post]
        match 'generate_phone_code',via:[:get,:post]
        get 'need_captcha'
        post 'signup'
        post 'recover_password'
      end
    end
    resources :product_categories do
      resources :products
    end
    resources :carts
    resources :collections
    resources :banners, only: [:index]
    resources :musics, only: [:index]
    resources :bags, only: [:index]
    resources :shoes, only: [:index]
    resources :cosmetics, only: [:index]
    resources :visitor_logs, only: [:index]
    resources :coupons, only:[:index] do
      member do
        get 'take'
      end
    end

    resources :grades,only: [:index,:create]

    get 'lottery/records',to: "lotteries#records"

    resources :lotteries,:mall_items,:agglomerations,only: [:index] do
      member do
        get 'images'
        get 'detail'
        post 'order'
        get  'records'
      end
    end

    get 'lottery/record_count',to: "lotteries#record_count"

    resources :jobs,only: [:index,:show] do
      member do
        get 'images'
        get 'detail'
      end
    end

    get 'job/categories',to: 'jobs#categories'

    # resources :lottery_orders,only: [:create]

    get "areas/:name/streets",to: "areas#streets"
    resources :areas,only: [:index]
    resources :users,path:'user',only:[] do
      collection do
        match 'fund',via: [:get,:post]
        get 'messages'
        get 'coupons'
        get 'coupon_count'
        get 'lottery_records'
      end
    end

    resources :unboxings,only: [:index,:create]

    resources :addresses,only: [:index,:create,:destroy]

    resources :shares,only: [:index,:create]

    get "address/default" => "addresses#default"

    resources :orders ,only:[:index,:create,:destroy]

    resources :payments,only:[:create]

    match "payment/pay", to: "payments#pay", via: [:get, :post]

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
    resources :coupons
    resources :agglomerations
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

    resources :lotteries
    resources :mall_items
    resources :banners
    resources :jobs

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

    resources :vendors
    root 'dashboard#index'
  end
end

Rails.application.routes.draw do
  root 'home#index'

  get 'search', to: 'search#show'

  resources :promotions do
    member do
      post 'generate_coupons'
      post 'approve'
    end
  end

  resources :coupons do
    post 'disable', on: :member
    post 'enable', on: :member
  end

  resources :product_categories

  devise_for :users, controllers: { registrations: 'registrations' }
  resources :users, only: [:show]

  namespace :api, constraints: ->(req) { req.format == :json } do
    namespace :v1 do
      resources :coupons, only: [:show], param: :code
    end
  end
end

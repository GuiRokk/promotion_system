Rails.application.routes.draw do
  root 'home#index'

  get 'search', to: 'search#show'

  resources :promotions do
    post 'generate_coupons', on: :member
    post 'approve',          on: :member
  end

  resources :coupons do
    post 'disable', on: :member
    post 'enable',  on: :member
  end

  resources :product_categories

  devise_for :users, controllers: { registrations: 'registrations' }
  resources :users, only: [:show]
end

Rails.application.routes.draw do

  root 'home#index'
  get 'search', to: 'search#show'

  resources :promotions, only: %i[index show new create edit update destroy] do    #literals => %i
    post 'generate_coupons', on: :member
  end

  resources :product_categories, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :coupons, only: [] do
    post 'disable', on: :member
    post  'enable', on: :member
  end

  devise_for :users, controllers: {registrations:  'registrations'}
  resources :users, only: [:show]
end
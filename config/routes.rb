Rails.application.routes.draw do

  root 'home#index'

  resources :promotions, only: %i[index show new create edit update destroy] do    #literals => %i
    post 'generate_coupons', on: :member
  end

  resources :product_categories, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :coupons, only: [] do
    post 'disable', on: :member
  end

end

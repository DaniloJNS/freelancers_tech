Rails.application.routes.draw do
  devise_for :professionals
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  
  resources :projects, only: [:new, :index, :show, :create] do
    get 'public', on: :collection
  end
end

# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  devise_for :professionals
  devise_for :users

  root to: 'home#index'

  resources :projects, only: %i[new show create index] do
    collection do
      get 'public'
      get 'search'
    end
    member do
      post :closed
      get :team
    end
    resources :proposals, only: %i[create show index], shallow: true do
      member do
        get :approval
        post :approval
        post :accepted
        get :refused
        post :refused
        post :cancel
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :projects, only: %i[index show]
    end
  end

  namespace :professionals, as: :professional do
    resources :projects, only: %i[index] do
      get :team
    end
    resources :profiles, only: %i[new create show], shallow: true do
      resources :formations, only: %i[new create], shallow: true
      resources :experiences, only: %i[new create], shallow: true
    end
  end
end

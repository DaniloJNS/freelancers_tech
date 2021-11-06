# == Route Map
#

Rails.application.routes.draw do
  devise_for :professionals
  devise_for :users

  root to: 'home#index'
  post 'ajax', to: 'home#ajax'

  resources :projects, only: %i[new show create index] do
    collection do
      get 'public'
      get 'search'
    end
    post :closed, on: :member
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

  resources :professionals do
    resources :profiles, only: %i[new create], shallow: true do
      resources :formations, only: %i[new create], shallow: true
      resources :experiences, only: %i[new create], shallow: true
    end
  end

  scope ':name', as: 'professional' do
    get 'my_projects', to: 'professionals/projects#index', as: :projects
    get ':title', to: 'professionals/projects#show', as: :project
  end
end

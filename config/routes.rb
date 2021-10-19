Rails.application.routes.draw do
  devise_for :professionals
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  
  resources :projects, only: [:new, :index, :show, :create, :update] do
    get 'public', on: :collection
    get 'search', on: :collection
    resources :proposals, only: %i[create show index], shallow: true
  end
  
  match 'proposals/:id', to: 'proposals#update', via: [:patch, :put, :post]
  resources :professionals do
    resources :profiles, only: %i[ new create]
  end
  scope ':name', as: 'professional' do
    get 'my_projects', to: 'professionals/projects#index', as: :projects
    get ':title', to: 'professionals/projects#show', as: :project
  end
end

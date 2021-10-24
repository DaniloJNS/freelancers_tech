Rails.application.routes.draw do
  devise_for :professionals
  devise_for :users

  root to: 'home#index'
  
  resources :projects, only: [:new, :show, :create, :index] do
    collection do
      get 'public'
      get 'search'
    end
    post :closed, on: :member
    resources :proposals, only: %i[create show index], shallow: true do
      member do
        get 'approval'
        post :accepted
        post :refused
        post :cancel
      end
    end
  end
  
  resources :professionals do
    resources :profiles, only: %i[ new create]
  end

  scope ':name', as: 'professional' do
    get 'my_projects', to: 'professionals/projects#index', as: :projects
    get ':title', to: 'professionals/projects#show', as: :project
  end

end

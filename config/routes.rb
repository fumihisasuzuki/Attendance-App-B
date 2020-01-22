Rails.application.routes.draw do
  get 'bases/new'

  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  
  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'edit_approving_overtime'
      patch 'update_approving_overtime'
    end
    resources :attendances, only: :update do
      member do
        get 'edit_overtime'
        patch 'update_overtime'
      end
    end
    collection { post :import }
    get 'index_members_during_work'
  end
  
  resources :bases

end

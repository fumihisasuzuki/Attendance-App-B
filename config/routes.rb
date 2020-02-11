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
      get 'attendances/edit_approving_one_month' #新規追加
      patch 'attendances/update_approving_one_month' #新規追加
      get 'attendances/edit_applying_change'
      patch 'attendances/update_applying_change'
      get 'attendances/edit_approving_change'
      patch 'attendances/update_approving_change'
      get 'attendances/edit_approving_overtime'
      patch 'attendances/update_approving_overtime'
      get 'index_attendances_log'
    end
    resources :attendances, only: :update do
      member do
        get 'edit_overtime'
        patch 'update_overtime'
        patch 'update_one_month' #新規追加
      end
    end
    collection { post :import }
    get 'index_members_during_work'
  end
  
  resources :bases

end

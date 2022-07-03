Rails.application.routes.draw do
  get 'reports/new'

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      get 'basic_info'
      get 'bases'
      get 'in_attendance'
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'attendances/notice_overtime'
      get 'attendances/notice_change_at'
      get 'reports/notice_report'
    end
    resources :attendances, only: :update
  end
    resources :bases
end
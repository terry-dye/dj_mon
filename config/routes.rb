DjMon::Engine.routes.draw do
  
  resources :dj_reports, :only=> [ :index ] do
    collection do
      get :all
      get :failed
      get :active
      get :queued
      get :dj_counts
    end
  end

  root :to => 'dj_reports#index'
end

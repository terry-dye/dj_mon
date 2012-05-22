DjMon::Engine.routes.draw do
  
  resources :delayed_jobs, :only=> [ :index ] do
    collection do
      get :all
      get :failed
      get :active
      get :queued
    end
  end

  root :to => 'delayed_jobs#index', :as => :delayed_jobs
end

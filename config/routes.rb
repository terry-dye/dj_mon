DjMon::Engine.routes.draw do
  root :to => 'delayed_jobs#index', :as => :delayed_jobs
end
ReportCat::Engine.routes.draw do

  root :to => 'reports#index'

  resources :reports, :only => [ :index, :show ]
end

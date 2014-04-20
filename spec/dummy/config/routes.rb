Rails.application.routes.draw do

  mount ReportCat::Engine => '/report_cat'

  root :to => 'root#index'

  get '/login', :to => 'root#login'
  get '/logout', :to => 'root#logout'

  get ':controller(/:action(/:id))'

end

Rails.application.routes.draw do

  mount ReportCat::Engine => '/report_cat'

  root :to => 'root#index'

  get ':controller(/:action(/:id))'

end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # This just makes the reports reload in development

  before_action :require_reports if Rails.env.development?

  def authenticate!
    render :plain => 'forbidden' unless cookies[ :login ]
  end

  def authorize!
  end

  def require_reports
    Dir[Rails.root + 'app/reports/**/*.rb'].each { |path| require_dependency path }
  end

end

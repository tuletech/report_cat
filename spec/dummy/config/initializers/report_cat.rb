ReportCat.configure do |config|

  config.authenticate_with do
    authenticate! unless Rails.env.test?
  end

  config.authorize_with do
    authorize! unless Rails.env.test?
  end

  config.layout = 'admin'
end
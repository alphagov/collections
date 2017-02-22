Collections::Application.configure do
  config.slimmer.logger = Rails.logger

  if Rails.env.development?
    config.slimmer.asset_host = Plek.current.find('static')
  end
end

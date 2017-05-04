require 'securerandom'

if ENV['ERRBIT_API_KEY'].present?
  Airbrake.configure do |config|
    config.project_key = ENV['ERRBIT_API_KEY']
    config.project_id = 1000000000000 # We are not using this on our current errbit
    config.host = Plek.find_uri('errbit').host
    config.environment = ENV['ERRBIT_ENVIRONMENT_NAME']
  end
end

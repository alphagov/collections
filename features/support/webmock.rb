require "webmock/cucumber"

WebMock.disable_net_connect!(
  allow_localhost: true, # Capybara needs access to itself.
  allow: ["chromedriver.storage.googleapis.com"],
)

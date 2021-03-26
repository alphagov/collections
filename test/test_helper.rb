# Duplicated in features/support/env.rb
ENV["GOVUK_WEBSITE_ROOT"] = "http://www.test.gov.uk"
ENV["GOVUK_APP_DOMAIN"] = "test.gov.uk"
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../config/environment", __dir__)
require "rails/test_help"
require "mocha/minitest"

require "webmock/minitest"
WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: ["chromedriver.storage.googleapis.com"],
)

require "gds_api/test_helpers/content_store"
require "gds_api/test_helpers/search"

Dir[Rails.root.join("test/support/*.rb")].sort.each { |f| require f }

# Most tests use ActiveSupport TestCase behaviour, so we configure this here.

class ActiveSupport::TestCase
  include GdsApi::TestHelpers::ContentStore
  include GdsApi::TestHelpers::Search

  setup do
    I18n.locale = :en
  end

  after do
    WebMock.reset!
  end
end

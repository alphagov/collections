if ENV["USE_SIMPLECOV"]
  require "simplecov"
  require "simplecov-rcov"
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start "rails"
end

# Duplicated in features/support/env.rb
ENV["GOVUK_WEBSITE_ROOT"] = "http://www.test.gov.uk"
ENV["GOVUK_APP_DOMAIN"] = "test.gov.uk"
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../config/environment", __dir__)
require "rails/test_help"
require "mocha/minitest"

require "webmock/minitest"
WebMock.disable_net_connect!(allow_localhost: true)

Dir[Rails.root.join("test/support/*.rb")].sort.each { |f| require f }

require "gds_api/test_helpers/content_store"
require "gds_api/test_helpers/search"

# Most tests use ActiveSupport TestCase behaviour, so we configure this here.

# For integration tests that use capybara, we configure GovukAbTesting
# accordingly before/after the tests.
GovukAbTesting.configure do |config|
  config.acceptance_test_framework = :active_support
end

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

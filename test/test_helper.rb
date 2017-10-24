if ENV["USE_SIMPLECOV"]
  require "simplecov"
  require "simplecov-rcov"
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start 'rails'
end

# Duplicated in features/support/env.rb
ENV["GOVUK_WEBSITE_ROOT"] = "http://www.test.gov.uk"
ENV["GOVUK_APP_DOMAIN"] = "test.gov.uk"
ENV["GOVUK_ASSET_ROOT"] = "http://static.test.gov.uk"
ENV["RAILS_ENV"] ||= "test"

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

require 'webmock/minitest'
WebMock.disable_net_connect!

Dir[Rails.root.join('test/support/*.rb')].each { |f| require f }

require 'gds_api/test_helpers/content_store'
require 'slimmer/test_helpers/govuk_components'
require 'gds_api/test_helpers/rummager'

# Most tests use ActiveSupport TestCase behaviour, so we configure this here.

class ActiveSupport::TestCase
  include GdsApi::TestHelpers::ContentStore
  include Slimmer::TestHelpers::GovukComponents
  include GdsApi::TestHelpers::Rummager

  before do
    stub_shared_component_locales
  end

  after do
    WebMock.reset!
  end
end

ENV["GOVUK_WEBSITE_ROOT"] = "http://www.test.gov.uk"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "mocha/setup"

require 'webmock/minitest'
WebMock.disable_net_connect!

Dir[Rails.root.join('test/support/*.rb')].each { |f| require f }

require 'gds_api/test_helpers/content_api'
require 'gds_api/test_helpers/collections_api'
require 'gds_api/test_helpers/content_store'
require 'gds_api/test_helpers/rummager'

class ActiveSupport::TestCase
  include GdsApi::TestHelpers::ContentApi
  include GdsApi::TestHelpers::CollectionsApi
  include GdsApi::TestHelpers::ContentStore
  include GdsApi::TestHelpers::Rummager

  GovukContentSchemaTestHelpers.configure do |config|
    config.schema_type = 'frontend'
    config.project_root = Rails.root
  end

  after do
    WebMock.reset!
  end
end

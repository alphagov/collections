ENV["RAILS_ENV"] ||= "test"
ENV["GOVUK_WEBSITE_ROOT"] = "http://www.test.gov.uk"
ENV["GOVUK_APP_DOMAIN"] = "test.gov.uk"

require File.expand_path("../config/environment", __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "gds_api/test_helpers/search"
require "gds_api/test_helpers/content_store"
require "webmock/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.include GdsApi::TestHelpers::Search
  config.include GdsApi::TestHelpers::ContentStore
  config.include ActiveSupport::Testing::TimeHelpers
  config.use_active_record = false
  config.infer_spec_type_from_file_location!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

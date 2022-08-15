if ENV["USE_SIMPLECOV"]
  require "simplecov"
  require "simplecov-rcov"
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
end

if ENV["USE_I18N_COVERAGE"]
  require "i18n/coverage"
  require "i18n/coverage/printers/file_printer"
  I18n::Coverage.config.printer = I18n::Coverage::Printers::FilePrinter
  I18n::Coverage.start
end

# Duplicated in features/support/env.rb
ENV["RAILS_ENV"] ||= "test"
ENV["GOVUK_WEBSITE_ROOT"] = "http://www.test.gov.uk"
ENV["GOVUK_APP_DOMAIN"] = "test.gov.uk"

require File.expand_path("../config/environment", __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "gds_api/test_helpers/search"
require "gds_api/test_helpers/content_store"
require "webmock/rspec"
WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: ["chromedriver.storage.googleapis.com"],
)

Capybara.automatic_label_click = true

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

GovukAbTesting.configure do |config|
  config.acceptance_test_framework = :active_support
end

# Ensure the Cost of Living page is visible for integration tests
Rails.application.config.show_cost_of_living_landing_page = true

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

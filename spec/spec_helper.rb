require "simplecov"
require "simplecov-rcov"
SimpleCov.start do
  formatter SimpleCov::Formatter::RcovFormatter
  enable_coverage :branch
  minimum_coverage 95
end

if ENV["USE_I18N_COVERAGE"]
  require "i18n/coverage"
  require "i18n/coverage/printers/file_printer"
  I18n::Coverage.config.printer = I18n::Coverage::Printers::FilePrinter
  I18n::Coverage.start
end

# Duplicated in features/support/env.rb
ENV["RAILS_ENV"] ||= "test"
ENV["RACK_ENV"] ||= "test"
ENV["GOVUK_WEBSITE_ROOT"] = "http://www.test.gov.uk"
ENV["GOVUK_APP_DOMAIN"] = "test.gov.uk"

require File.expand_path("../config/environment", __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "gds_api/test_helpers/search"
require "gds_api/test_helpers/content_store"
require "gds_api/test_helpers/publishing_api"
require "webmock/rspec"
WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: ["chromedriver.storage.googleapis.com"],
)

Capybara.automatic_label_click = true

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

GovukAbTesting.configure do |config|
  config.acceptance_test_framework = :capybara
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.include GdsApi::TestHelpers::Search
  config.include GdsApi::TestHelpers::ContentStore
  config.include GdsApi::TestHelpers::PublishingApi
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

def fetch_fixture(filename)
  json = File.read(
    Rails.root.join("spec", "fixtures", "content_store", "#{filename}.json"),
  )
  JSON.parse(json)
end

def fetch_graphql_fixture(filename)
  json = File.read(
    Rails.root.join("spec", "fixtures", "graphql", "#{filename}.json"),
  )
  JSON.parse(json)
end

def search_api_response(titles_and_links_hash)
  results_array = titles_and_links_hash.to_a.map do |title, link|
    {
      'link': link,
      'title': title,
      'public_timestamp': "2016-10-07T22:18:32Z",
      'display_type': "some_display_type",
    }
  end
  { 'results': results_array }
end

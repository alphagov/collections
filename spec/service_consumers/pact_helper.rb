require "pact/provider/rspec"
require "webmock/rspec"
require_relative "../../test/support/organisations_api_test_helper"
require ::File.expand_path("../../config/environment", __dir__)

Pact.configure do |config|
  config.reports_dir = "spec/reports/pacts"
  config.include WebMock::API
  config.include WebMock::Matchers
  config.include OrganisationsApiTestHelper
end

class ProxyApp
  def initialize(real_provider_app)
    @real_provider_app = real_provider_app
  end

  def call(env)
    env["HTTP_HOST"] = "localhost:3002"
    response = @real_provider_app.call(env)
    response
  end
end

def url_encode(str)
  ERB::Util.url_encode(str)
end

def pact_broker_base_url
  "https://pact-broker.cloudapps.digital"
end

Pact.service_provider "Collections Organisation API" do
  app { ProxyApp.new(Rails.application) }
  honours_pact_with "GDS API Adapters" do
    if ENV["PACT_URI"]
      pact_uri(ENV["PACT_URI"])
    else
      path = "pacts/provider/#{url_encode(name)}/consumer/#{url_encode(consumer_name)}"
      version_modifier = "versions/#{url_encode(ENV.fetch('GDS_API_ADAPTERS_PACT_VERSION', 'master'))}"
      pact_uri("#{pact_broker_base_url}/#{path}/#{version_modifier}")
    end
  end
end

Pact.provider_states_for "GDS API Adapters" do
  set_up do
    WebMock.enable!
    WebMock.reset!
  end

  tear_down do
    WebMock.disable!
  end

  provider_state "there is a list of organisations" do
    set_up do
      Services
      .search_api
      .stub(:search)
      .with(organisations_params) { search_api_organisations_results }
    end
  end

  provider_state "the organisation list is paginated, beginning at page 1" do
    set_up do
      Services
      .search_api
      .stub(:search)
      .with(organisations_params) { search_api_organisations_two_pages_of_results }
    end
  end

  provider_state "the organisation list is paginated, beginning at page 2" do
    set_up do
      Services
      .search_api
      .stub(:search)
      .with(organisations_params(start: 20)) { search_api_organisations_two_pages_of_results }
    end
  end

  provider_state "the organisation hmrc exists" do
    set_up do
      Services
      .search_api
      .stub(:search)
      .with(
        organisation_params(slug: "hm-revenue-customs"),
      ) { search_api_organisation_results }
    end
  end

  provider_state "no organisation exists" do
    set_up do
      Services
      .search_api
      .stub(:search)
      .with(
        organisation_params(slug: "department-for-making-life-better"),
      ) { search_api_organisation_no_results }
    end
  end
end

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
    env["HTTP_HOST"] = "localhost:4000"
    response = @real_provider_app.call(env)
    response
  end
end

Pact.service_provider "Organisations API" do
  app { ProxyApp.new(Rails.application) }
  honours_pact_with "GDS API Adapters" do
    pact_uri "../gds-api-adapters/spec/pacts/gds_api_adapters-collections_organisation_api.json"
  end
end

Pact.provider_states_for "GDS API Adapters" do
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
      ##
    end
  end

  provider_state "no organisation exists" do
    set_up do
      ##
    end
  end
end

require 'gds_api/test_helpers/content_api'
require 'gds_api/test_helpers/rummager'

module SpecialistSectorHelper
  include GdsApi::TestHelpers::ContentApi
  include GdsApi::TestHelpers::Rummager

  def stub_specialist_sector_tag_lookups
    @content = %w{
      what-is-oil
      apply-for-an-oil-licence
      environmental-policy
      onshore-exploration-and-production
      well-application-form
      well-report-2014
      oil-extraction-count-2013
    }

    @organisations = %w{
      government/organisations/department-of-energy-climate-change
      government/organisations/air-accidents-investigation-branch
    }

    content_api_has_tag("specialist_sector","oil-and-gas/fields-and-wells","oil-and-gas")
    content_api_has_artefacts_with_a_tag("specialist_sector", "oil-and-gas/fields-and-wells", @content)

    Collections::Application.config.search_client.stubs(:unified_search).with(
      count: "0",
      filter_specialist_sectors: ["oil-and-gas/fields-and-wells"],
      facet_organisations: "1000",
    ).returns(
      rummager_has_specialist_sector_organisations(
        "oil-and-gas/fields-and-wells",
      )
    )
  end

  def visit_specialist_sector_topic
    visit "/oil-and-gas/fields-and-wells"
  end

  def assert_presence_of_specialist_sector_content
    @content.each do |slug|
      assert page.has_selector?("a[href='http://frontend.test.gov.uk/#{slug}']")
    end
  end

  def assert_presence_of_organisations
    @organisations.each do |slug|
      assert page.has_selector?("a[href='/#{slug}'][class='organisation-link']")
    end
  end
end

World(SpecialistSectorHelper)

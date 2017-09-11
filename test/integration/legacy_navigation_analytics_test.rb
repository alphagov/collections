require 'integration_test_helper'

class LegacyNavigationAnalyticsTest < ActionDispatch::IntegrationTest
  include GovukAbTesting::MinitestHelpers
  include AnalyticsHelpers
  include GdsApi::TestHelpers::ContentItemHelpers
  include RummagerHelpers

  before do
    @existing_framework = GovukAbTesting.configuration.acceptance_test_framework

    GovukAbTesting.configure do |config|
      config.acceptance_test_framework = :capybara
    end
  end

  after do
    Capybara.reset_sessions!

    GovukAbTesting.configure do |config|
      config.acceptance_test_framework = @existing_framework
    end
  end

  def setup_content_item(basepath)
    item = content_item_for_base_path(basepath).merge(
      "content_id" => 'dummy-content-id',
      "links" => {
        "active_top_level_browse_page" => [{
          "title" => 'Foo',
          "base_path" => '/foo',
          "description" => 'foo',
          "content_id" => 'foo'
        }],
        "parent" => [{
          "title" => 'Foo',
          "base_path" => '/foo',
          "description" => 'foo',
          "content_id" => 'foo'
        }]
      }
    )
    content_store_has_item(basepath, item)
  end

  test "Legacy browse pages in AB scope have analytics meta tag" do
    path = '/browse/education'
    setup_content_item(path)
    with_variant EducationNavigation: "A" do
      visit path
      assert page_has_meta_tag?('govuk:navigation-legacy', 'education')
    end
  end

  test "Second level browse pages in AB scope have analytics meta tag" do
    path = '/browse/education/find-course'
    rummager_has_documents_for_second_level_browse_page('dummy-content-id', ['foo'])
    setup_content_item(path)
    with_variant EducationNavigation: "A" do
      visit path
      assert page_has_meta_tag?('govuk:navigation-legacy', 'education')
    end
  end

  test "Legacy Topic pages in AB scope have analytics meta tag" do
    path = '/topic/further-education-skills'
    setup_content_item(path)
    with_variant EducationNavigation: "A" do
      visit path
      assert page_has_meta_tag?('govuk:navigation-legacy', 'education')
    end
  end

  test "Subtopic pages in AB scope have analytics meta tag" do
    path = '/topic/further-education-skills/apprenticeships'
    setup_subtopic_organisations('dummy-content-id')
    rummager_has_documents_for_subtopic('dummy-content-id', ['foo'])
    setup_content_item(path)
    with_variant EducationNavigation: "A" do
      visit path
      assert page_has_meta_tag?('govuk:navigation-legacy', 'education')
    end
  end

  def setup_subtopic_organisations(subtopic_content_id)
    Services.rummager.stubs(:search).with(
      count: "0",
      filter_topic_content_ids: [subtopic_content_id],
      facet_organisations: "1000"
    ).returns(
      "facets" => {
        "organisations" => {
          "options" => [
            "value" => {
              "title" => 'foo',
              "link" => 'bar'
            }
          ]
        }
      }
    )
  end

  def rummager_has_documents_for_subtopic(subtopic_content_id, document_slugs, format = "guide", page_size: 1000)
    results = document_slugs.map.with_index do |slug, i|
      rummager_document_for_slug(slug, (i + 1).hours.ago, format)
    end

    results.each_slice(page_size).with_index do |results_page, page|
      start = page * page_size
      Services.rummager.stubs(:search).with(
        start: start,
        count: page_size,
        filter_topic_content_ids: [subtopic_content_id],
        fields: %w(title link format),
      ).returns("results" => results_page,
        "start" => start,
        "total" => results.size)
    end
  end
end

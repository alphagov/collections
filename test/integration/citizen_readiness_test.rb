require 'integration_test_helper'

class CitizenReadinessTest < ActionDispatch::IntegrationTest
  it "renders links to citizen relevant content correctly" do
    when_i_visit_the_citizen_readiness_page
    then_i_can_see_the_correct_title
    and_i_can_see_email_signup_with_tracking
    and_i_can_see_featured_links_with_tracking
    and_i_can_see_featured_taxons_with_tracking
    and_i_can_see_other_taxons_with_tracking
  end

  def when_i_visit_the_citizen_readiness_page
    base_path = "/prepare-eu-exit"
    stub_citizen_readiness_page(base_path)

    dummy_crime_taxon_id = SecureRandom.uuid
    dummy_health_taxon_id = SecureRandom.uuid
    stub_homepage(dummy_crime_taxon_id, dummy_health_taxon_id)
    stub_other_topics(dummy_crime_taxon_id, dummy_health_taxon_id)

    visit base_path
  end

  def then_i_can_see_the_correct_title
    page.assert_selector "h1", text: "Prepare for EU exit"
  end

  def and_i_can_see_email_signup_with_tracking
    page.assert_selector ".app-c-email-link[data-module=track-click][data-track-category=emailAlertLinkClicked][data-track-action='/government/brexit']",
      text: "Sign up for updates about EU Exit on all GOV.UK pages"
  end

  def and_i_can_see_featured_links_with_tracking
    within first('.campaign__taxon') do
      page.assert_selector "a[data-track-category=navGridContentClicked][data-track-action=0][data-track-label='Visit Europe after Brexit']",
        text: "Visit Europe after Brexit"
    end
  end

  def and_i_can_see_featured_taxons_with_tracking
    page.assert_selector ".campaign__taxon a[data-track-category][data-track-action][data-track-label]", count: 5
    page.assert_selector ".campaign__taxon a[data-track-action=1]",
      text: "Work and things"
    page.assert_selector ".campaign__taxon a[data-track-action=4]",
      text: "Education, training and skills"
  end

  def and_i_can_see_other_taxons_with_tracking
    page.assert_selector "h3.campaign__other-topics-title",
      text: "Other EU Exit topics"
    within ".campaign__other-topics-list" do
      page.assert_selector "a[href='/prepare-eu-exit/crime-and-law'][data-track-category=sideNavTopics][data-track-action='Crime, justice and law']"
      page.assert_selector "a[href='/prepare-eu-exit/health-care'][data-track-category=sideNavTopics][data-track-action='Health and social care']"
    end
  end

  def stub_citizen_readiness_page(base_path)
    content_item = GovukSchemas::RandomExample.for_schema(frontend_schema: 'special_route') do |payload|
      payload.merge(title: "Prepare for EU exit", base_path: base_path)
    end
    content_store_has_item(base_path, content_item)
  end

  def stub_homepage(crime_taxon_id, health_taxon_id)
    base_path = "/"

    taxons = [
      taxon_example("/going-and-being-abroad", "Going and being abroad"),
      taxon_example("/work", "Work and things"),
      taxon_example("/transport", "Getting about"),
      taxon_example("/environment", "Food, farming, fresh air"),
      taxon_example("/business-and-industry", "Other sorts of work and things"),
      taxon_example("/education", "Education, training and skills"),
      taxon_example("/crime-and-law", "Crime, justice and law", crime_taxon_id),
      taxon_example("/health-care", "Health and social care", health_taxon_id)
    ]
    content_item = GovukSchemas::RandomExample.for_schema(frontend_schema: 'homepage') do |payload|
      payload.merge(links: { level_one_taxons: taxons })
    end
    content_store_has_item(base_path, content_item)
  end

  def taxon_example(base_path, title, content_id = SecureRandom.uuid)
    GovukSchemas::RandomExample.for_schema(frontend_schema: 'taxon') do |payload|
      payload.merge(base_path: base_path, title: title, content_id: content_id)
    end
  end

  CITIZEN_TAXON_CONTENT_ID = 'd7bdaee2-8ea5-460e-b00d-6e9382eb6b61'.freeze

  def stub_other_topics(crime_taxon_id, health_taxon_id)
    params = {
          count: 0,
          facet_part_of_taxonomy_tree: "1000,examples:0,scope:all_filters",
          filter_taxons: CITIZEN_TAXON_CONTENT_ID,
          filter_content_store_document_type: %w(travel_advice_index) + GovukDocumentTypes.supergroup_document_types('guidance_and_regulation', 'services')
        }

    Services.rummager.stubs(:search)
      .with(params)
      .returns(
        "results" => [],
        "start" => 0,
        "total" => 99,
        "facets" => {
          "part_of_taxonomy_tree" => {
            "options" => [
              {
                "value" => {
                  "slug" => crime_taxon_id
                }
              },
              {
                "value" => {
                  "slug" => health_taxon_id
                }
              }
            ]
          }
        }
      )
  end
end

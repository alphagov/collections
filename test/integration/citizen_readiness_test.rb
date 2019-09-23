require "integration_test_helper"

class CitizenReadinessTest < ActionDispatch::IntegrationTest
  it "renders links to citizen relevant content correctly" do
    when_i_visit_the_citizen_readiness_page
    then_i_can_see_the_correct_title
    and_the_page_has_metatags
    and_i_can_see_featured_links_with_tracking
    and_i_can_see_other_campaigns_with_tracking
  end

  def when_i_visit_the_citizen_readiness_page
    base_path = "/prepare-eu-exit"
    stub_citizen_readiness_page(base_path)
    visit base_path
  end

  def then_i_can_see_the_correct_title
    page.assert_selector "h1", text: "Prepare for Brexit"
  end

  def and_the_page_has_metatags
    page.assert_selector("meta[name='description'][content='Prepare yourself for Brexit']", visible: false)
  end

  def and_i_can_see_featured_links_with_tracking
    page.assert_selector ".campaign__taxon a[data-track-category][data-track-action][data-track-label]", count: 4

    within first(".campaign__taxon") do
      page.assert_selector "a[data-track-category=navGridContentClicked][data-track-action=0][data-track-label='Visiting Europe']",
                           text: "Visiting Europe"
    end
  end

  def and_i_can_see_other_campaigns_with_tracking
    page.assert_selector ".campaign__other-campaigns-title", text: "Other guidance"

    within ".campaign__other-campaigns-list" do
      page.assert_selector ".campaign__other-campaigns-item", count: 3
      page.assert_selector "a[href='/business-uk-leaving-eu'][data-track-category=sideNavTopics][data-track-action='running a business']"
    end
  end

  def stub_citizen_readiness_page(base_path)
    content_item = GovukSchemas::RandomExample.for_schema(frontend_schema: "special_route") do |payload|
      payload.merge(title: "Prepare for Brexit", base_path: base_path, description: "Prepare yourself for Brexit")
    end
    content_store_has_item(base_path, content_item)
  end
end

require 'integration_test_helper'

class TopicBrowsingTest < ActionDispatch::IntegrationTest

  def stub_specialist_sector_organisations(slug)
    Collections::Application.config.search_client.stubs(:unified_search).with(
      count: "0",
      filter_specialist_sectors: [slug],
      facet_organisations: "1000",
    ).returns(
      rummager_has_specialist_sector_organisations(slug)
    )
  end

  it "renders a topic tag page and list its subtopics" do
    subtopics = [
      { slug: "oil-and-gas/wells", title: "Wells", description: "Wells, wells, wells." },
      { slug: "oil-and-gas/fields", title: "Fields", description: "Fields, fields, fields." },
      { slug: "oil-and-gas/offshore", title: "Offshore", description: "Information about offshore oil and gas." },
    ]

    content_api_has_tag("specialist_sector", { slug: "oil-and-gas", title: "Oil and gas", description: "Guidance for the oil and gas industry" })
    content_api_has_sorted_child_tags("specialist_sector", "oil-and-gas", "alphabetical", subtopics)

    visit "/oil-and-gas"
    assert page.has_title?("Oil and gas - GOV.UK")

    within "header.page-header" do
      assert page.has_content?("Oil and gas")
    end

    within ".category-description" do
      assert page.has_content?("Guidance for the oil and gas industry")
    end

    within ".topics ul" do
      within "li:nth-child(1)" do
        assert page.has_link?("Wells")
      end

      within "li:nth-child(2)" do
        assert page.has_link?("Fields")
      end

      within "li:nth-child(3)" do
        assert page.has_link?("Offshore")
      end
    end
  end

  it "renders a subtopic and its artefacts" do
    stubbed_response = collections_api_has_content_for("/oil-and-gas/wells")
    stubbed_response_body = JSON.parse(stubbed_response.response.body)
    example_stubbed_artefact = stubbed_response_body['details']['groups'][0]

    stub_specialist_sector_organisations('oil-and-gas/wells')

    visit "/oil-and-gas/wells"

    assert page.has_title?("Oil and gas: #{stubbed_response_body['title']} - GOV.UK")

    within "header.page-header" do
      assert page.has_content?("Oil and gas")
      assert page.has_content?(stubbed_response_body['title'])

      assert page.has_link?('Subscribe to email alerts', href: email_signup_path(topic_slug: 'oil-and-gas', subcategory: 'wells'))
    end

    assert page.has_content?(example_stubbed_artefact['contents'][0]['title'])
  end

  it 'does not display a link to itself on the latest feed' do
    base_path = 'oil-and-gas/wells'

    stub_specialist_sector_organisations(base_path)
    collections_api_has_content_for("/#{base_path}")

    visit "/#{base_path}/latest"

    within "header.page-header" do
      assert page.has_link?('Subscribe to email alerts', href: email_signup_path(topic_slug: 'oil-and-gas', subcategory: 'wells'))
      assert page.has_no_link?('See latest changes')
    end
  end

  it 'renders pagination for the latest changes' do
    base_path = '/oil-and-gas/wells'

    # stub the request for a list of associated organisations
    stub_specialist_sector_organisations('oil-and-gas/wells')

    # stubs the request for the first page of results
    collections_api_has_content_for(base_path,
      return_body_options: { total: 75 }
    )
    # stubs the request for the second page of results
    collections_api_has_content_for(base_path,
      start: '50',
      return_body_options: { start: 50, total: 75 }
    )

    visit "#{base_path}/latest"

    assert page.has_link?('Next page', href: "#{base_path}/latest?start=50")
    assert page.has_no_link?('Previous page')

    click_on 'Next page'

    assert page.has_no_link?('Next page')
    assert page.has_link?('Previous page', href: "#{base_path}/latest")
  end
end

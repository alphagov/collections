require 'integration_test_helper'

class SubtopicPageTest < ActionDispatch::IntegrationTest
  include RummagerHelpers

  setup do
    content_api_has_tag("specialist_sector", "oil-and-gas")
    content_api_has_tag("specialist_sector", "oil-and-gas/offshore", "oil-and-gas")
    content_api_has_artefacts_with_a_tag(
      'specialist_sector', 'oil-and-gas/offshore',
      [
        'oil-rig-safety-requirements',
        'oil-rig-staffing',
        'north-sea-shipping-lanes',
        'undersea-piping-restrictions'
      ]
    )
  end

  describe "for a curated subtopic" do
    setup do
      content_store_has_item("/oil-and-gas/offshore", {
        base_path: "/oil-and-gas/offshore",
        title: "Offshore",
        description: "Offshore drilling and exploration",
        format: "topic",
        public_updated_at: 10.days.ago.iso8601,
        details: {
          groups: [
            {
              name: "Oil rigs",
              contents: [
                "#{Plek.current.find("contentapi")}/oil-rig-staffing.json",
                "#{Plek.current.find("contentapi")}/oil-rig-safety-requirements.json",
              ],
            },
            {
              name: "Piping",
              contents: [
                "#{Plek.current.find("contentapi")}/undersea-piping-restrictions.json",
              ],
            },
          ]
        },
        links: {
          "parent" => [
            "title"=>"Oil and Gas",
            "base_path"=>"/oil-and-gas",
          ]
        },
      })

      stub_topic_organisations('oil-and-gas/offshore')
    end

    it "displays the subtopic page" do
      # When I visit the subtopic page
      visit "/oil-and-gas/offshore"

      # Then I should see the subtopic metadata
      within '.page-header' do
        within 'h1' do
          assert page.has_content?("Oil and Gas")
          assert page.has_content?("Offshore")
        end

        within '.metadata' do
          # The orgs are fixed in the rummager test helpers
          assert page.has_link?("Department of Energy & Climate Change")
          assert page.has_link?("Foreign & Commonwealth Office")
        end
      end

      # And I should see the curated content for the subtopic
      assert page.has_link?("Oil rig staffing", :href => "/oil-rig-staffing")
      assert page.has_link?("Oil rig safety requirements", :href => "/oil-rig-safety-requirements")
      assert page.has_link?("Undersea piping restrictions", :href => "/undersea-piping-restrictions")

      refute page.has_link?("North sea shipping lanes")
    end
  end


  describe "for a non-curated subtopic" do
    setup do
      content_store_has_item("/oil-and-gas/offshore", {
        base_path: "/oil-and-gas/offshore",
        title: "Offshore",
        description: "Offshore drilling and exploration",
        format: "topic",
        public_updated_at: 10.days.ago.iso8601,
        details: {
          groups: [],
        },
        links: {
          "parent" => [
            "title"=>"Oil and Gas",
            "base_path"=>"/oil-and-gas",
          ]
        },
      })
      stub_topic_organisations('oil-and-gas/offshore')
    end

    it "displays the subtopic page" do
      # When I visit the subtopic page
      visit "/oil-and-gas/offshore"

      # Then I should see the subtopic metadata
      within '.page-header' do
        within 'h1' do
          assert page.has_content?("Oil and Gas")
          assert page.has_content?("Offshore")
        end

        within '.metadata' do
          # The orgs are fixed in the rummager test helpers
          assert page.has_link?("Department of Energy & Climate Change")
          assert page.has_link?("Foreign & Commonwealth Office")
        end
      end

      # And I should see all content for the subtopic
      assert page.has_link?("Oil rig staffing", :href => "/oil-rig-staffing")
      assert page.has_link?("Oil rig safety requirements", :href => "/oil-rig-safety-requirements")
      assert page.has_link?("North sea shipping lanes", :href => "/north-sea-shipping-lanes")
      assert page.has_link?("Undersea piping restrictions", :href => "/undersea-piping-restrictions")
    end
  end
end

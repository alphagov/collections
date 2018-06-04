require 'integration_test_helper'

class ContentStoreOrganisationsTest < ActionDispatch::IntegrationTest
  before do
    @content_item = {
        details: {
            ordered_ministerial_departments: [
                {
                    title: "Attorney General's Office",
                    href: "/government/organisations/attorney-generals-office",
                    brand: "attorney-generals-office",
                    logo: {
                        formatted_title: "Attorney General's Office",
                        crest: "single-identity"
                    },
                    separate_website: false,
                    works_with: {
                        non_ministerial_department: [
                            {
                                title: "Crown Prosecution Service",
                                href: "/government/organisations/crown-prosecution-service"
                            },
                            {
                                title: "Government Legal Department",
                                href: "/government/organisations/government-legal-department"
                            },
                            {
                                title: "Serious Fraud Office",
                                href: "/government/organisations/serious-fraud-office"
                            }
                        ],
                        other: [
                            {
                                title: "HM Crown Prosecution Service Inspectorate",
                                href: "/government/organisations/hm-crown-prosecution-service-inspectorate"
                            }
                        ],
                        executive_ndpb: []
                    }
                }
            ],
            ordered_executive_offices: [],
            ordered_non_ministerial_departments: [],
            ordered_agencies_and_other_public_bodies: [],
            ordered_high_profile_groups: [],
            ordered_public_corporations: [],
            ordered_devolved_administrations: []
        }
    }

    content_store_has_item('/government/organisations', @content_item)
  end

  it "is possible to visit the organisations index page, which includes title" do
    visit "/government/organisations"
    assert page.has_title?("Departments, agencies and public bodies - GOV.UK")
  end

  it "is possible to visit the organisation page and return 200" do
    visit "/government/organisations"
    assert_equal 200, page.status_code
  end

  it "is possible to see a list of organisations" do
    visit "/government/organisations"
    assert page.has_content?(@content_item[:details][:ordered_ministerial_departments][0][:title])
  end

  it "displays Ministerial department to be one" do
    visit "/government/organisations"
    assert page.has_selector?(".department-count", text: "1")
  end

  # Commenting this out until this functionality has been added
  # Will be added as part of: https://trello.com/c/DUFbZjjM/166-add-works-with-info-to-organisation-list-page

#   it "displays child organisations count" do
#     visit "/government/organisations"
#     assert page.has_content?("Works with 4 agencies and public bodies")
#   end

  it "displays department name" do
    visit "/government/organisations"
    assert page.has_content?("Non ministerial departments")
  end
end

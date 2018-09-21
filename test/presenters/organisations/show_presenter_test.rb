require 'test_helper'

describe Organisations::ShowPresenter do
  include RummagerHelpers
  include OrganisationHelpers

  it 'adds a prefix to a title when it should' do
    content_item = ContentItem.new({ title: "Attorney General's Office" }.with_indifferent_access)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = "the Attorney General's Office"
    assert_equal expected, @show_presenter.prefixed_title
  end

  it 'does not add a prefix to a title when it should not' do
    content_item = ContentItem.new({ title: "The Charity Commission" }.with_indifferent_access)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = "The Charity Commission"
    assert_equal expected, @show_presenter.prefixed_title

    content_item = ContentItem.new({ title: "civil service resourcing" }.with_indifferent_access)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = "civil service resourcing"
    assert_equal expected, @show_presenter.prefixed_title
  end

  it 'returns a link to a parent organisation' do
    content_hash = {
      title: "Export Control Joint Unit",
      details: {
        organisation_type: "sub_organisation"
      },
      links: {
        ordered_parent_organisations: [{
          base_path: "/international-trade",
          title: "Department for International Trade"
        }]
      }
    }
    content_item = ContentItem.new(content_hash.with_indifferent_access)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = "<a class=\"brand__color\" href=\"/international-trade\">Department for International Trade</a>"

    assert_equal expected, @show_presenter.parent_organisations
  end

  it 'returns a human-readable sentence with links to multiple parent organisation' do
    content_hash = {
      title: "Export Control Joint Unit",
      details: {
        organisation_type: "sub_organisation"
      },
      links: {
        ordered_parent_organisations:
        [
          {
            base_path: "/international-trade-1",
            title: "Dept for Trade"
          },
          {
            base_path: "/international-trade-2",
            title: "Second Dept for Trade"
          }
        ]
      }
    }
    content_item = ContentItem.new(content_hash.with_indifferent_access)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = "<a class=\"brand__color\" href=\"/international-trade-1\">Dept for Trade</a> and <a class=\"brand__color\" href=\"/international-trade-2\">Second Dept for Trade</a>"

    assert_equal expected, @show_presenter.parent_organisations
  end

  it 'formats high profile groups correctly' do
    content_item = ContentItem.new(organisation_with_high_profile_groups)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = {
      title: "High profile groups within Defra",
      brand: "department-for-environment-food-rural-affairs",
      items: [
        {
          text: "Rural Development Programme for England Network",
          path: "/government/organisations/rural-development-programme-for-england-network"
        },
        {
          text: "Rural Development Programme for England Network 2",
          path: "/government/organisations/rural-development-programme-for-england-network-2"
        }
      ]
    }

    assert_equal expected, @show_presenter.high_profile_groups
  end

  it "formats corporate information correctly" do
    content_item = ContentItem.new(organisation_with_corporate_information)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = {
      corporate_information_links: {
        items: [{
          text: "Corporate Information page",
          path: "/corporate-info"
        }],
        brand: "attorney-generals-office",
        margin_bottom: true
      },
      job_links: {
        items: [
          {
            text: "Jobs",
            path: "/jobs"
          },
          {
            text: "Working for Attorney General's Office",
            path: "/government/attorney-general's-office/recruitment"
          },
          {
            text: "Procurement at Attorney General's Office",
            path: "/government/attorney-general's-office/procurement"
          }
        ],
        brand: "attorney-generals-office",
        margin_bottom: true
      }
    }

    assert_equal expected, @show_presenter.corporate_information
  end
end

require "test_helper"

describe Organisations::ShowPresenter do
  include SearchApiHelpers
  include OrganisationHelpers

  it "adds a prefix to a title when it should" do
    presenter = build_show_presenter_for_org("Attorney General's Office", "ministerial_department")
    assert_equal "the Attorney General's Office", presenter.prefixed_title

    presenter = build_show_presenter_for_org("Queen's Bench Division of the High Court", "court")
    assert_equal "the Queen's Bench Division of the High Court", presenter.prefixed_title
  end

  it "does not add a prefix to a title when it should not" do
    presenter = build_show_presenter_for_org("The Charity Commission", "non_ministerial_department")
    assert_equal "The Charity Commission", presenter.prefixed_title

    presenter = build_show_presenter_for_org("civil service resourcing", "sub_organisation")
    assert_equal "civil service resourcing", presenter.prefixed_title

    presenter = build_show_presenter_for_org("civil service hr", "sub_organisation")
    assert_equal "civil service hr", presenter.prefixed_title
  end

  def build_show_presenter_for_org(title, type)
    content_item = ContentItem.new({ title: title,
                                     details: { organisation_type: type } }.with_indifferent_access)

    organisation = Organisation.new(content_item)
    Organisations::ShowPresenter.new(organisation)
  end

  it "returns a link to a parent organisation" do
    content_hash = {
      title: "Export Control Joint Unit",
      details: {
        organisation_type: "sub_organisation",
      },
      links: {
        ordered_parent_organisations: [{
          base_path: "/international-trade",
          title: "Department for International Trade",
        }],
      },
    }
    content_item = ContentItem.new(content_hash.with_indifferent_access)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = "<a class=\"brand__color govuk-link\" href=\"/international-trade\">Department for International Trade</a>"

    assert_equal expected, @show_presenter.parent_organisations
  end

  it "returns a human-readable sentence with links to multiple parent organisation" do
    content_hash = {
      title: "Export Control Joint Unit",
      details: {
        organisation_type: "sub_organisation",
      },
      links: {
        ordered_parent_organisations:
        [
          {
            base_path: "/international-trade-1",
            title: "Dept for Trade",
          },
          {
            base_path: "/international-trade-2",
            title: "Second Dept for Trade",
          },
        ],
      },
    }
    content_item = ContentItem.new(content_hash.with_indifferent_access)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = "<a class=\"brand__color govuk-link\" href=\"/international-trade-1\">Dept for Trade</a> and <a class=\"brand__color govuk-link\" href=\"/international-trade-2\">Second Dept for Trade</a>"

    assert_equal expected, @show_presenter.parent_organisations
  end

  it "formats high profile groups correctly and in alphabetical order" do
    content_item = ContentItem.new(organisation_with_high_profile_groups)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = {
      title: "High profile groups within Defra",
      brand: "department-for-environment-food-rural-affairs",
      items: [
        {
          text: "Another Rural Development Programme for England Network",
          path: "/government/organisations/another-rural-development-programme-for-england-network",
        },
        {
          text: "Rural Development Programme for England Network",
          path: "/government/organisations/rural-development-programme-for-england-network",
        },
      ],
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
          path: "/corporate-info",
        }],
        brand: "attorney-generals-office",
        margin_bottom: true,
      },
      job_links: {
        items: [
          {
            text: "Jobs",
            path: "/jobs",
          },
          {
            text: "Working for Attorney General's Office",
            path: "/government/attorney-general's-office/recruitment",
          },
          {
            text: "Procurement at Attorney General's Office",
            path: "/government/attorney-general's-office/procurement",
          },
        ],
        brand: "attorney-generals-office",
        margin_bottom: true,
      },
    }

    assert_equal expected, @show_presenter.corporate_information
  end
end

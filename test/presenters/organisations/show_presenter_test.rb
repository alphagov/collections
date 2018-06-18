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

  it 'formats policies correctly' do
    content_item = ContentItem.new(organisation_with_ministers)
    organisation = Organisation.new(content_item)
    @show_presenter = Organisations::ShowPresenter.new(organisation)

    expected = {
      items: [
        {
          link: {
            text: "Waste and recycling",
            path: "/government/policies/waste-and-recycling"
          }
        },
        {
          link: {
            text: "See all our policies",
            path: "/government/policies?organisations[]=attorney-generals-office"
          }
        }
      ],
      brand: "attorney-generals-office"
    }

    assert_equal expected, @show_presenter.featured_policies
  end
end

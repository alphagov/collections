require 'test_helper'

describe Organisations::FeaturedNewsPresenter do
  include RummagerHelpers
  include OrganisationHelpers

  before :each do
    content_item = ContentItem.new(organisation_with_ministers)
    organisation = Organisation.new(content_item)
    @featured_news_presenter = Organisations::FeaturedNewsPresenter.new(organisation)
  end

  it 'formats the main large news story correctly' do
    expected = {
      href: "/government/news/new-head-of-the-serious-fraud-office-announced",
      image_src: "https://assets.publishing.service.gov.uk/jeremy.jpg",
      image_alt: "Attorney General Jeremy Wright QC MP",
      context: "4 June 2018 — Press release",
      heading_text: "New head of the Serious Fraud Office announced",
      description: "Lisa Osofsky appointed new Director of the Serious Fraud Office ",
      brand: "attorney-generals-office",
      large: true
    }
    assert_equal expected, @featured_news_presenter.first_featured_news
  end

  it 'formats the remaining news stories correctly' do
    expected = [{
      href: "/government/news/new-head-of-a-different-office-announced",
      image_src: "https://assets.publishing.service.gov.uk/john.jpg",
      image_alt: "John Someone MP",
      context: "4 June 2017 — Policy paper",
      heading_text: "New head of a different office announced",
      description: "John Someone appointed new Director of the Other Office ",
      brand: "attorney-generals-office"
    }]
    assert_equal expected, @featured_news_presenter.remaining_featured_news
  end
end

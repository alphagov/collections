require "test_helper"

describe Organisations::HeaderPresenter do
  include OrganisationHelpers

  it "formats data for the translation component correctly" do
    content_item = ContentItem.new(organisation_with_translations)
    organisation = Organisation.new(content_item)
    @header_presenter = Organisations::HeaderPresenter.new(organisation)

    expected = {
      brand: "attorney-generals-office",
      no_margin_top: true,
      translations: [
        {
          locale: "en",
          base_path: "/government/organisations/office-of-the-secretary-of-state-for-wales",
          text: "English",
          active: true,
        },
        {
          locale: "cy",
          base_path: "/government/organisations/office-of-the-secretary-of-state-for-wales.cy",
          text: "Cymraeg",
          active: nil,
        },
      ],
    }
    assert_equal expected, @header_presenter.translation_links
  end
end

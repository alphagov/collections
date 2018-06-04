require 'test_helper'

describe OrganisationsPresenter do
  include RummagerHelpers
  include OrganisationsHelpers

  describe '#ministerial_departments' do
    before :each do
      content_item = ContentItem.new(ministerial_departments_hash)
      content_store_organisations = ContentStoreOrganisations.new(content_item)
      @organisations_presenter = OrganisationsPresenter.new(content_store_organisations)
    end

    it 'returns title for organisations page' do
      assert_equal "Departments, agencies and public bodies", @organisations_presenter.title
    end

    it 'returns executive offices as part of ministerial_departments hash' do
      expected = [{
        "title": "Prime Minister's Office, 10 Downing Street",
        "href": "/government/organisations/prime-ministers-office-10-downing-street",
        "brand": "cabinet-office",
        "logo": {
          "formatted_title": "Prime Minister's Office, 10 Downing Street",
          "crest": "eo"
        }
      }.with_indifferent_access]

      assert_equal expected, @organisations_presenter.ministerial_departments[:number_10]
    end

    it 'returns ministerial departments as part of ministerial_departments hash' do
      expected = [{
        "title": "Attorney General's Office",
        "href": "/government/organisations/attorney-generals-office"
      }.with_indifferent_access]

      assert_equal expected, @organisations_presenter.ministerial_departments[:ministerial_departments]
    end
  end
end

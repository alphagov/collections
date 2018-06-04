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

  describe '#non_ministerial_departments' do
    before :each do
      content_item = ContentItem.new(non_ministerial_departments_hash)
      content_store_organisations = ContentStoreOrganisations.new(content_item)
      @organisations_presenter = OrganisationsPresenter.new(content_store_organisations)
    end

    it 'formats data for document list component' do
      expected = [{
        link: {
          text: "The Charity Commission",
          path: "/government/organisations/charity-commission"
        }
      }]

      assert_equal expected, @organisations_presenter.non_ministerial_departments[:non_ministerial_departments]
    end

    it 'returns agencies_and_other_public_bodies departments as part of non_ministerial_departments hash' do
      expected = [{
        link: {
          text: "Academy for Social Justice Commissioning",
          path: "/government/organisations/academy-for-social-justice-commissioning",
        }
      }]

      assert_equal expected, @organisations_presenter.non_ministerial_departments[:agencies_and_other_public_bodies]
    end

    it 'returns high_profile_groups departments as part of non_ministerial_departments hash' do
      expected = [{
        link: {
          text: "Bona Vacantia",
          path: "/government/organisations/bona-vacantia",
        }
      }]

      assert_equal expected, @organisations_presenter.non_ministerial_departments[:high_profile_groups]
    end

    it 'returns public_corporations departments as part of non_ministerial_departments hash' do
      expected = [{
        link: {
          text: "BBC",
          path: "/government/organisations/bbc",
        }
      }]

      assert_equal expected, @organisations_presenter.non_ministerial_departments[:public_corporations]
    end

    it 'returns devolved_administrations departments as part of non_ministerial_departments hash' do
      expected = [{
        link: {
          text: "Northern Ireland Executive ",
          path: "/government/organisations/northern-ireland-executive",
        }
      }]

      assert_equal expected, @organisations_presenter.non_ministerial_departments[:devolved_administrations]
    end
  end

  describe 'some non_ministerial_departments' do
    before :each do
      content_item = ContentItem.new(some_non_ministerial_departments_hash)
      content_store_organisations = ContentStoreOrganisations.new(content_item)
      @organisations_presenter = OrganisationsPresenter.new(content_store_organisations)
    end

    it 'returns empty arrays where there are no organisations' do
      expected = {
        non_ministerial_departments: [{
          link: {
            text: "The Charity Commission",
            path: "/government/organisations/charity-commission",
          }
        }],
        agencies_and_other_public_bodies: [],
        high_profile_groups: [],
        public_corporations: [],
        devolved_administrations: []
      }

      assert_equal expected, @organisations_presenter.non_ministerial_departments
    end
  end
end

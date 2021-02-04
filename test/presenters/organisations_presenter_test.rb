require "test_helper"

describe Organisations::IndexPresenter do
  include SearchApiHelpers
  include OrganisationsHelpers

  describe "ministerial departments" do
    before :each do
      content_item = ContentItem.new(ministerial_departments_hash)
      content_store_organisations = ContentStoreOrganisations.new(content_item)
      @organisations_presenter = Organisations::IndexPresenter.new(content_store_organisations)
    end

    it "returns title for organisations page" do
      assert_equal "Departments, agencies and public bodies", @organisations_presenter.title
    end

    it "returns executive offices as part of all_organisations hash" do
      expected = [{
        "title": "Prime Minister's Office, 10 Downing Street",
        "href": "/government/organisations/prime-ministers-office-10-downing-street",
        "brand": "cabinet-office",
        "logo": {
          "formatted_title": "Prime Minister's Office, 10 Downing Street",
          "crest": "eo",
        },
      }.with_indifferent_access]

      assert_equal expected, @organisations_presenter.all_organisations[:number_10]
    end

    it "returns ministerial departments as part of all_organisations hash" do
      expected = [{
        "title": "Attorney General's Office",
        "href": "/government/organisations/attorney-generals-office",
      }.with_indifferent_access]

      assert_equal expected, @organisations_presenter.all_organisations[:ministerial_departments]
    end
  end

  describe "non_ministerial_departments" do
    before :each do
      content_item = ContentItem.new(non_ministerial_departments_hash)
      content_store_organisations = ContentStoreOrganisations.new(content_item)
      @organisations_presenter = Organisations::IndexPresenter.new(content_store_organisations)
    end

    it "returns agencies_and_other_public_bodies departments as part of all_organisations hash" do
      expected = [{
        "title": "The Charity Commission",
        "href": "/government/organisations/charity-commission",
        "brand": "department-for-business-innovation-skills",
        "separate_website": true,
      }.with_indifferent_access]

      assert_equal expected, @organisations_presenter.all_organisations[:non_ministerial_departments]
    end

    it "returns agencies_and_other_public_bodies departments as part of all_organisations hash" do
      expected = [{
        "title": "Academy for Social Justice Commissioning",
        "href": "/government/organisations/academy-for-social-justice-commissioning",
        "brand": "ministry-of-justice",
      }.with_indifferent_access]

      assert_equal expected, @organisations_presenter.all_organisations[:agencies_and_other_public_bodies]
    end

    it "returns high_profile_groups departments as part of all_organisations hash" do
      expected = [{
        "title": "Bona Vacantia",
        "href": "/government/organisations/bona-vacantia",
        "brand": "attorney-generals-office",
      }.with_indifferent_access]

      assert_equal expected, @organisations_presenter.all_organisations[:high_profile_groups]
    end

    it "returns public_corporations departments as part of all_organisations hash" do
      expected = [{
        "title": "BBC",
        "href": "/government/organisations/bbc",
        "brand": "department-for-culture-media-sport",
      }.with_indifferent_access]

      assert_equal expected, @organisations_presenter.all_organisations[:public_corporations]
    end

    it "returns devolved_administrations departments as part of all_organisations hash" do
      expected = [{
        "title": "Northern Ireland Executive ",
        "href": "/government/organisations/northern-ireland-executive",
        "brand": nil,
      }.with_indifferent_access]

      assert_equal expected, @organisations_presenter.all_organisations[:devolved_administrations]
    end
  end

  describe "#works_with_statement" do
    before :each do
      content_item = ContentItem.new(some_non_ministerial_departments_hash)
      content_store_organisations = ContentStoreOrganisations.new(content_item)
      @organisations_presenter = Organisations::IndexPresenter.new(content_store_organisations)
    end

    it "returns nil when organisation does not work with others" do
      assert_nil @organisations_presenter.works_with_statement({})
    end

    it "returns string when organisation works with one other" do
      test_org = {
        works_with: {
          non_ministerial_department: [
            {
              title: "Crown Prosecution Service",
              path: "/government/organisations/crown-prosecution-service",
            },
          ],
        },
      }.with_indifferent_access

      assert_equal "Works with 1 public body", @organisations_presenter.works_with_statement(test_org)
    end

    it "returns string when organisation works with multiple others" do
      test_org = {
        works_with: {
          non_ministerial_department: [
            {
              title: "Crown Prosecution Service",
              path: "/government/organisations/crown-prosecution-service",
            },
          ],
          other: [
            {
              title: "HM Crown Prosecution Service Inspectorate",
              path: "/government/organisations/hm-crown-prosecution-service-inspectorate",
            },
          ],
        },
      }.with_indifferent_access

      assert_equal "Works with 2 agencies and public bodies", @organisations_presenter.works_with_statement(test_org)
    end
  end

  describe "#ordered_works_with" do
    before :each do
      content_item = ContentItem.new(some_non_ministerial_departments_hash)
      content_store_organisations = ContentStoreOrganisations.new(content_item)
      @organisations_presenter = Organisations::IndexPresenter.new(content_store_organisations)
    end

    it "returns [] when organisation does not work with others" do
      assert_equal [], @organisations_presenter.ordered_works_with({})
    end

    it "returns organisation groups in the correct order" do
      test_org = {
        works_with: {
          other: [
            {
              title: "HM Crown Prosecution Service Inspectorate",
              path: "/government/organisations/hm-crown-prosecution-service-inspectorate",
            },
          ],
          non_ministerial_department: [
            {
              title: "Crown Prosecution Service",
              path: "/government/organisations/crown-prosecution-service",
            },
          ],
        },
      }.with_indifferent_access

      expected = [
        [
          "non_ministerial_department",
          [
            {
              "title" => "Crown Prosecution Service",
              "path" => "/government/organisations/crown-prosecution-service",
            },
          ],
        ],
        [
          "other",
          [
            {
              "title" => "HM Crown Prosecution Service Inspectorate",
              "path" => "/government/organisations/hm-crown-prosecution-service-inspectorate",
            },
          ],
        ],
      ]

      assert_equal expected, @organisations_presenter.ordered_works_with(test_org)
    end
  end

  describe "organisation type" do
    before :each do
      content_item = ContentItem.new(ministerial_departments_hash)
      content_store_organisations = ContentStoreOrganisations.new(content_item)
      @organisations_presenter = Organisations::IndexPresenter.new(content_store_organisations)
    end

    it "executive_office? returns true if organisation is number_10" do
      test_organisation_type = :number_10
      assert @organisations_presenter.executive_office?(test_organisation_type)
    end

    it "executive_office? returns false if organisation is not number_10" do
      test_organisation_type_ministerial = :ministerial_departments
      test_organisation_type_non_ministerial = :public_corporations

      assert_not @organisations_presenter.executive_office?(test_organisation_type_ministerial)
      assert_not @organisations_presenter.executive_office?(test_organisation_type_non_ministerial)
    end

    it "ministerial_organisation? returns true if organisation is number_10" do
      test_organisation_type = :number_10

      assert @organisations_presenter.ministerial_organisation?(test_organisation_type)
    end

    it "ministerial_organisation? returns true if organisation is ministerial department" do
      test_organisation_type = :ministerial_departments

      assert @organisations_presenter.ministerial_organisation?(test_organisation_type)
    end

    it "ministerial_organisation? returns false if organisation is non ministerial department" do
      test_organisation_type = :agencies_and_other_public_bodies

      assert_not @organisations_presenter.ministerial_organisation?(test_organisation_type)
    end
  end
end

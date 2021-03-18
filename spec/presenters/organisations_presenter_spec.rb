RSpec.describe Organisations::IndexPresenter do
  include OrganisationsHelpers

  describe "ministerial departments" do
    let(:organisations_presenter) { presenter_from_hash(ministerial_departments_hash) }

    it "returns title for organisations page" do
      expect(organisations_presenter.title).to eq("Departments, agencies and public bodies")
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

      expect(organisations_presenter.all_organisations[:number_10]).to eq(expected)
    end

    it "returns ministerial departments as part of all_organisations hash" do
      expected = [{
        "title": "Attorney General's Office",
        "href": "/government/organisations/attorney-generals-office",
      }.with_indifferent_access]

      expect(organisations_presenter.all_organisations[:ministerial_departments]).to eq(expected)
    end
  end

  describe "non_ministerial_departments" do
    let(:organisations_presenter) { presenter_from_hash(non_ministerial_departments_hash) }

    it "returns agencies_and_other_public_bodies departments as part of all_organisations hash" do
      expected = [{
        "title": "The Charity Commission",
        "href": "/government/organisations/charity-commission",
        "brand": "department-for-business-innovation-skills",
        "separate_website": true,
      }.with_indifferent_access]

      expect(organisations_presenter.all_organisations[:non_ministerial_departments]).to eq(expected)
    end

    it "returns agencies_and_other_public_bodies departments as part of all_organisations hash" do
      expected = [{
        "title": "Academy for Social Justice Commissioning",
        "href": "/government/organisations/academy-for-social-justice-commissioning",
        "brand": "ministry-of-justice",
      }.with_indifferent_access]

      expect(organisations_presenter.all_organisations[:agencies_and_other_public_bodies]).to eq(expected)
    end

    it "returns high_profile_groups departments as part of all_organisations hash" do
      expected = [{
        "title": "Bona Vacantia",
        "href": "/government/organisations/bona-vacantia",
        "brand": "attorney-generals-office",
      }.with_indifferent_access]

      expect(organisations_presenter.all_organisations[:high_profile_groups]).to eq(expected)
    end

    it "returns public_corporations departments as part of all_organisations hash" do
      expected = [{
        "title": "BBC",
        "href": "/government/organisations/bbc",
        "brand": "department-for-culture-media-sport",
      }.with_indifferent_access]

      expect(organisations_presenter.all_organisations[:public_corporations]).to eq(expected)
    end

    it "returns devolved_administrations departments as part of all_organisations hash" do
      expected = [{
        "title": "Northern Ireland Executive ",
        "href": "/government/organisations/northern-ireland-executive",
        "brand": nil,
      }.with_indifferent_access]

      expect(organisations_presenter.all_organisations[:devolved_administrations]).to eq(expected)
    end
  end

  describe "#works_with_statement" do
    let(:organisations_presenter) { presenter_from_hash(some_non_ministerial_departments_hash) }

    it "returns nil when organisation does not work with others" do
      expect(organisations_presenter.works_with_statement({})).to be_nil
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

      expect(organisations_presenter.works_with_statement(test_org)).to eq("Works with 1 public body")
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

      expect(organisations_presenter.works_with_statement(test_org)).to eq("Works with 2 agencies and public bodies")
    end
  end

  describe "#ordered_works_with" do
    let(:organisations_presenter) { presenter_from_hash(some_non_ministerial_departments_hash) }

    it "returns [] when organisation does not work with others" do
      expect(organisations_presenter.ordered_works_with({})).to eq([])
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

      expect(organisations_presenter.ordered_works_with(test_org)).to eq(expected)
    end
  end

  describe "organisation type" do
    let(:organisations_presenter) { presenter_from_hash(ministerial_departments_hash) }

    it "executive_office? returns true if organisation is number_10" do
      test_organisation_type = :number_10
      expect(organisations_presenter.executive_office?(test_organisation_type)).to be true
    end

    it "executive_office? returns false if organisation is not number_10" do
      test_organisation_type_ministerial = :ministerial_departments
      test_organisation_type_non_ministerial = :public_corporations

      expect(organisations_presenter.executive_office?(test_organisation_type_ministerial)).to be false
      expect(organisations_presenter.executive_office?(test_organisation_type_non_ministerial)).to be false
    end

    it "ministerial_organisation? returns true if organisation is number_10" do
      test_organisation_type = :number_10

      expect(organisations_presenter.ministerial_organisation?(test_organisation_type)).to be true
    end

    it "ministerial_organisation? returns true if organisation is ministerial department" do
      test_organisation_type = :ministerial_departments

      expect(organisations_presenter.ministerial_organisation?(test_organisation_type)).to be true
    end

    it "ministerial_organisation? returns false if organisation is non ministerial department" do
      test_organisation_type = :agencies_and_other_public_bodies

      expect(organisations_presenter.ministerial_organisation?(test_organisation_type)).to_not be true
    end
  end

  def presenter_from_hash(content)
    content_item = ContentItem.new(content)
    content_store_organisations = ContentStoreOrganisations.new(content_item)
    Organisations::IndexPresenter.new(content_store_organisations)
  end
end

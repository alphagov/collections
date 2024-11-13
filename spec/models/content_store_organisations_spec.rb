RSpec.describe ContentStoreOrganisations do
  include OrganisationsHelpers

  subject { described_class.new(ContentItem.new(non_ministerial_departments_hash)) }

  describe "#all" do
    it "returns all organisations" do
      all_organisations = [
        {
          title: "The Charity Commission",
          href: "/government/organisations/charity-commission",
          brand: "department-for-business-innovation-skills",
          separate_website: true,
        }.with_indifferent_access,
        {
          title: "Academy for Social Justice Commissioning",
          href: "/government/organisations/academy-for-social-justice-commissioning",
          brand: "ministry-of-justice",
        }.with_indifferent_access,
        {
          title: "Bona Vacantia",
          href: "/government/organisations/bona-vacantia",
          brand: "attorney-generals-office",
        }.with_indifferent_access,
        {
          title: "BBC",
          href: "/government/organisations/bbc",
          brand: "department-for-culture-media-sport",
        }.with_indifferent_access,
        {
          title: "Northern Ireland Executive ",
          href: "/government/organisations/northern-ireland-executive",
          brand: nil,
        }.with_indifferent_access,
      ]
      expect(subject.all).to eq(all_organisations)
    end
  end

  describe "#by_href" do
    it "returns all organisations mapped by their href values" do
      all_organisations_map = {
        "/government/organisations/charity-commission" => {
          title: "The Charity Commission",
          href: "/government/organisations/charity-commission",
          brand: "department-for-business-innovation-skills",
          separate_website: true,
        },
        "/government/organisations/academy-for-social-justice-commissioning" => {
          title: "Academy for Social Justice Commissioning",
          href: "/government/organisations/academy-for-social-justice-commissioning",
          brand: "ministry-of-justice",
        },
        "/government/organisations/bona-vacantia" => {
          title: "Bona Vacantia",
          href: "/government/organisations/bona-vacantia",
          brand: "attorney-generals-office",
        },
        "/government/organisations/bbc" => {
          title: "BBC",
          href: "/government/organisations/bbc",
          brand: "department-for-culture-media-sport",
        },
        "/government/organisations/northern-ireland-executive" => {
          title: "Northern Ireland Executive ",
          href: "/government/organisations/northern-ireland-executive",
          brand: nil,
        },
      }.with_indifferent_access
      expect(subject.by_href).to eq(all_organisations_map)
    end
  end
end

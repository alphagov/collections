RSpec.describe OrganisationsSupport do
  include OrganisationsHelpers

  subject { Class.new { include OrganisationsSupport }.new }

  describe "#joining?" do
    let(:organisation) do
      {
        "govuk_status" => status,
      }
    end

    context "when organisation is joining" do
      let(:status) { "joining" }

      it "returns true" do
        expect(subject.joining?(organisation)).to be(true)
      end
    end

    context "when organisation is not live" do
      let(:status) { "live" }

      it "returns false" do
        expect(subject.joining?(organisation)).to be(false)
      end
    end

    context "when organisation is nil" do
      it "returns false" do
        expect(subject.joining?(nil)).to be(false)
      end
    end
  end

  describe "#reject_joining_organisations" do
    let(:organisations) do
      [
        {
          "title" => "Organisation A",
          "govuk_status" => "joining",
        },
        {
          "title" => "Organisation B",
          "govuk_status" => "live",
        },
      ]
    end

    it "rejects joining organisations" do
      expected = [
        {
          "title" => "Organisation B",
          "govuk_status" => "live",
        },
      ]

      expect(subject.reject_joining_organisations(organisations)).to eq(expected)
    end
  end

  describe "#works_with_categorised_links" do
    let(:organisation) do
      department_with_joining_organisation_hash.dig("details", "ordered_ministerial_departments", 0)
    end

    it "returns links to organisations this organisation works with" do
      expected = {
        executive_ndpb: [
          {
            title: "Coal Authority",
            href: "/government/organisations/the-coal-authority",
          },
          {
            title: "Mining Remediation Authority",
            href: "/government/organisations/mining-remediation-authority",
          },
        ],
      }.with_indifferent_access

      expect(subject.works_with_categorised_links(organisation)).to eq(expected)
    end
  end

  describe "#reject_empty_link_categories" do
    it "does not return empty categories" do
      categorised_links = {
        category_a: [
          {
            title: "link A",
          },
        ],
        category_b: [],
      }

      expected = {
        category_a: [
          {
            title: "link A",
          },
        ],
      }

      expect(subject.reject_empty_link_categories(categorised_links)).to eq(expected)
    end
  end

  describe "#reject_joining_links" do
    it "does not return joining links" do
      links = [
        {
          "title" => "link A",
          "href" => "/test/a",
        },
        {
          "title" => "link B",
          "href" => "/test/b",
        },
      ]

      organisation_map = {
        "/test/a" => { "govuk_status" => "joining" },
        "/test/b" => { "govuk_status" => "live" },
      }

      expected = [
        {
          "title" => "link B",
          "href" => "/test/b",
        },
      ]

      expect(subject.reject_joining_links(links, organisation_map)).to eq(expected)
    end
  end

  describe "#reject_joining_categorised_links" do
    it "does not return joining links or empty categories" do
      categorised_links = {
        "category_a" => [
          {
            "title" => "link A",
            "href" => "/test/a",
          },
          {
            "title" => "link B",
            "href" => "/test/b",
          },
        ],
        "category_b" => {},
      }

      organisation_map = {
        "/test/a" => { "govuk_status" => "joining" },
        "/test/b" => { "govuk_status" => "live" },
      }

      expected = {
        "category_a" => [
          {
            "title" => "link B",
            "href" => "/test/b",
          },
        ],
      }

      expect(subject.reject_joining_categorised_links(categorised_links, organisation_map)).to eq(expected)
    end
  end
end

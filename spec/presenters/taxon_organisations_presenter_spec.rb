RSpec.describe TaxonOrganisationsPresenter do
  include SearchApiHelpers
  include TaxonHelpers

  let(:content_hash) { funding_and_finance_for_students_taxon }
  let(:content_item) { ContentItem.new(content_hash) }
  let(:taxon) { Taxon.new(ContentItem.new(content_hash)) }
  let(:taxon_organisations_presenter) { TaxonOrganisationsPresenter.new(taxon.organisations, 5, 7) }

  it "checks whether organisations should be shown" do
    allow_any_instance_of(TaggedOrganisations).to receive(:fetch).and_return([])

    expect(taxon_organisations_presenter.show_organisations?).to be false
  end

  it "checks whether more organisations should be shown" do
    allow_any_instance_of(TaggedOrganisations).to receive(:fetch).and_return(multiple_organisations_with_logo)

    expect(taxon_organisations_presenter.show_more_organisations?).to be false
  end

  describe "#promoted_organisation_list" do
    it "returns a list of organisations without logos" do
      allow_any_instance_of(TaggedOrganisations).to receive(:fetch).and_return(tagged_organisation)

      promoted_without_logos = [
        {
          link: {
            text: "Department for Education",
            path: "/government/organisations/department-for-education",
            data_attributes: {
              track_category: "organisationsDocumentListClicked",
              track_action: 1,
              track_label: "/government/organisations/department-for-education",
              track_options: {
                dimension29: "Department for Education",
              },
              ga4_link: {
                event_name: "navigation",
                type: "organisation logo",
                index: {
                  index_link: 1,
                  index_section: 6,
                  index_section_count: 7,
                },
                index_total: 1,
                section: "Organisations",
              },
            },
          },
        },
      ]

      expected = {
        "promoted_with_logos": [],
        "promoted_without_logos": promoted_without_logos,
      }

      expect(taxon_organisations_presenter.promoted_organisation_list).to eq(expected)
    end

    it "returns a list of organisations with standard logos" do
      allow_any_instance_of(TaggedOrganisations).to receive(:fetch).and_return(tagged_organisation_with_logo)

      promoted_with_logos = [
        {
          name: 'Department\nfor\nEducation',
          url: "/government/organisations/department-for-education",
          brand: "department-for-education",
          crest: "single-identity",
          data_attributes: {
            track_category: "organisationsDocumentListClicked",
            track_action: 1,
            track_label: "/government/organisations/department-for-education",
            track_options: {
              dimension29: "Department for Education",
            },
            ga4_link: {
              event_name: "navigation",
              type: "organisation logo",
              index: {
                index_link: 1,
                index_section: 6,
                index_section_count: 7,
              },
              index_total: 1,
              section: "Organisations",
            },
          },
        },
      ]

      expected = {
        "promoted_with_logos": promoted_with_logos,
        "promoted_without_logos": [],
      }

      expect(taxon_organisations_presenter.promoted_organisation_list).to eq(expected)
    end

    it "returns a list of organisations with custom logos as a plain text list" do
      allow_any_instance_of(TaggedOrganisations).to receive(:fetch).and_return(tagged_custom_organisation)

      promoted_without_logos = [
        {
          link: {
            text: "Department for Education",
            path: "/government/organisations/department-for-education",
            data_attributes: {
              track_category: "organisationsDocumentListClicked",
              track_action: 1,
              track_label: "/government/organisations/department-for-education",
              track_options: {
                dimension29: "Department for Education",
              },
              ga4_link: {
                event_name: "navigation",
                type: "organisation logo",
                index: {
                  index_link: 1,
                  index_section: 6,
                  index_section_count: 7,
                },
                index_total: 1,
                section: "Organisations",
              },
            },
          },
        },
      ]

      expected = {
        "promoted_with_logos": [],
        "promoted_without_logos": promoted_without_logos,
      }

      expect(taxon_organisations_presenter.promoted_organisation_list).to eq(expected)
    end

    it "returns top 5 organisations with crests (if available) as promoted organisations" do
      allow_any_instance_of(TaggedOrganisations).to receive(:fetch).and_return(multiple_organisations_with_logo("single-identity"))

      promoted_with_logos = []

      5.times do |index|
        promoted_with_logos.push(
          name: 'Department\nfor\nEducation',
          url: "/government/organisations/department-for-education",
          brand: "department-for-education",
          crest: "single-identity",
          data_attributes: {
            track_category: "organisationsDocumentListClicked",
            track_action: index + 1,
            track_label: "/government/organisations/department-for-education",
            track_options: {
              dimension29: "Department for Education",
            },
            ga4_link: {
              event_name: "navigation",
              type: "organisation logo",
              index: {
                index_link: index + 1,
                index_section: 6,
                index_section_count: 7,
              },
              index_total: 5,
              section: "Organisations",
            },
          },
        )
      end

      expected = {
        "promoted_with_logos": promoted_with_logos,
        "promoted_without_logos": [],
      }

      expect(taxon_organisations_presenter.promoted_organisation_list).to eq(expected)
    end

    it "returns top 5 organisations without logos as promoted organisations if organisations with logos do not exist" do
      allow_any_instance_of(TaggedOrganisations).to receive(:fetch).and_return(multiple_organisations_with_logo)

      promoted_without_logos = []

      5.times do |index|
        promoted_without_logos.push(
          link: {
            text: "Department for Education",
            path: "/government/organisations/department-for-education",
            data_attributes: {
              track_category: "organisationsDocumentListClicked",
              track_action: index + 1,
              track_label: "/government/organisations/department-for-education",
              track_options: {
                dimension29: "Department for Education",
              },
              ga4_link: {
                event_name: "navigation",
                type: "organisation logo",
                index: {
                  index_link: index + 1,
                  index_section: 6,
                  index_section_count: 7,
                },
                index_total: 5,
                section: "Organisations",
              },
            },
          },
        )
      end

      expected = {
        "promoted_with_logos": [],
        "promoted_without_logos": promoted_without_logos,
      }

      expect(taxon_organisations_presenter.promoted_organisation_list).to eq(expected)
    end

    it "returns the organisations with and without logos as promoted content if less than 5 organisations have logos" do
      tagged_organisations = multiple_organisations_with_logo("single-identity", 3) + tagged_organisation

      allow_any_instance_of(TaggedOrganisations).to receive(:fetch).and_return(tagged_organisations)

      promoted_with_logos = []

      3.times do |index|
        promoted_with_logos.push(
          name: 'Department\nfor\nEducation',
          url: "/government/organisations/department-for-education",
          brand: "department-for-education",
          crest: "single-identity",
          data_attributes: {
            track_category: "organisationsDocumentListClicked",
            track_action: index + 1,
            track_label: "/government/organisations/department-for-education",
            track_options: {
              dimension29: "Department for Education",
            },
            ga4_link: {
              event_name: "navigation",
              type: "organisation logo",
              index: {
                index_link: index + 1,
                index_section: 6,
                index_section_count: 7,
              },
              index_total: 4,
              section: "Organisations",
            },
          },
        )
      end

      promoted_without_logos = [
        {
          link: {
            text: "Department for Education",
            path: "/government/organisations/department-for-education",
            data_attributes: {
              track_category: "organisationsDocumentListClicked",
              track_action: 4,
              track_label: "/government/organisations/department-for-education",
              track_options: {
                dimension29: "Department for Education",
              },
              ga4_link: {
                event_name: "navigation",
                type: "organisation logo",
                index: {
                  index_link: 4,
                  index_section: 6,
                  index_section_count: 7,
                },
                index_total: 4,
                section: "Organisations",
              },
            },
          },
        },
      ]

      expected = {
        "promoted_with_logos": promoted_with_logos,
        "promoted_without_logos": promoted_without_logos,
      }

      expect(taxon_organisations_presenter.promoted_organisation_list).to eq(expected)
    end
  end

  describe "#show_more_organisation_list" do
    it "shows a list of more organisations with a logo" do
      tagged_organisations = multiple_organisations_with_logo("single-identity") + tagged_organisation_with_logo

      allow_any_instance_of(TaggedOrganisations).to receive(:fetch).and_return(tagged_organisations)

      organisations_with_logos = [
        {
          name: 'Department\nfor\nEducation',
          url: "/government/organisations/department-for-education",
          brand: "department-for-education",
          crest: "single-identity",
          data_attributes: {
            track_category: "organisationsDocumentListClicked",
            track_action: 6,
            track_label: "/government/organisations/department-for-education",
            track_options: {
              dimension29: "Department for Education",
            },
            ga4_link: {
              event_name: "navigation",
              type: "organisation logo",
              index: {
                index_link: 6,
                index_section: 6,
                index_section_count: 7,
              },
              index_total: 6,
              section: "Organisations",
            },
          },
        },
      ]

      expected = {
        organisations_with_logos:,
        organisations_without_logos: [],
      }

      expect(taxon_organisations_presenter.show_more_organisation_list).to eq(expected)
    end

    it "shows a list of more organisations without a logo" do
      tagged_organisations = multiple_organisations_with_logo("single-identity") + tagged_organisation

      allow_any_instance_of(TaggedOrganisations).to receive(:fetch).and_return(tagged_organisations)

      organisations_without_logos = [
        {
          link: {
            text: "Department for Education",
            path: "/government/organisations/department-for-education",
            data_attributes: {
              track_category: "organisationsDocumentListClicked",
              track_action: 6,
              track_label: "/government/organisations/department-for-education",
              track_options: {
                dimension29: "Department for Education",
              },
              ga4_link: {
                event_name: "navigation",
                type: "organisation logo",
                index: {
                  index_link: 6,
                  index_section: 6,
                  index_section_count: 7,
                },
                index_total: 6,
                section: "Organisations",
              },
            },
          },
        },
      ]

      expected = {
        organisations_with_logos: [],
        organisations_without_logos:,
      }

      expect(taxon_organisations_presenter.show_more_organisation_list).to eq(expected)
    end
  end

private

  def tagged_organisation
    [
      SearchApiOrganisation.new(
        title: "Department for Education",
        content_id: "ebd15ade-73b2-4eaf-b1c3-43034a42eb37",
        link: "/government/organisations/department-for-education",
        slug: "department-for-education",
        organisation_state: "live",
        logo_formatted_title: nil,
        brand: nil,
        crest: nil,
        logo_url: nil,
        document_count: 89,
      ),
    ]
  end

  def tagged_organisation_with_logo
    [
      SearchApiOrganisation.new(
        title: "Department for Education",
        content_id: "ebd15ade-73b2-4eaf-b1c3-43034a42eb37",
        link: "/government/organisations/department-for-education",
        slug: "department-for-education",
        organisation_state: "live",
        logo_formatted_title: 'Department\nfor\nEducation',
        brand: "department-for-education",
        crest: "single-identity",
        logo_url: nil,
        document_count: 89,
      ),
    ]
  end

  def tagged_custom_organisation
    [
      SearchApiOrganisation.new(
        title: "Department for Education",
        content_id: "ebd15ade-73b2-4eaf-b1c3-43034a42eb37",
        link: "/government/organisations/department-for-education",
        slug: "department-for-education",
        organisation_state: "live",
        logo_formatted_title: 'Department\nfor\nEducation',
        brand: "department-for-education",
        crest: "custom",
        logo_url: "/logo-url.png",
        document_count: 89,
      ),
    ]
  end

  def multiple_organisations_with_logo(type = nil, number_of_organisations = 5)
    organisations = []

    number_of_organisations.times do
      organisations.push(
        SearchApiOrganisation.new(
          title: "Department for Education",
          content_id: "ebd15ade-73b2-4eaf-b1c3-43034a42eb37",
          link: "/government/organisations/department-for-education",
          slug: "department-for-education",
          organisation_state: "live",
          logo_formatted_title: 'Department\nfor\nEducation',
          brand: "department-for-education",
          crest: type,
          logo_url: nil,
          document_count: 89,
        ),
      )
    end

    organisations
  end
end

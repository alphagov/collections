require 'test_helper'

include RummagerHelpers
include TaxonHelpers

describe TaxonPresenter do
  describe 'options' do
    let(:content_hash) { funding_and_finance_for_students_taxon }
    let(:content_item) { ContentItem.new(content_hash) }
    let(:taxon) { Taxon.new(ContentItem.new(content_hash)) }
    let(:child_taxon) { taxon.child_taxons.first }
    let(:taxon_presenter) { TaxonPresenter.new(taxon) }

    describe '#options_for_child_taxon' do
      describe 'root options' do
        before :each do
          stub_content_for_taxon([taxon.content_id], generate_search_results(15))
        end

        subject { taxon_presenter.options_for_child_taxon(index: 0) }

        it 'contains the track-click module' do
          assert_equal('track-click', subject[:module])
        end

        it 'contains the navGridContentClicked track_category' do
          assert_equal('navGridContentClicked', subject[:track_category])
        end

        it 'contains track-action equal to the index + 1' do
          assert_equal('1', subject[:track_action])
        end

        it 'contains track_label equal to the base path of the child taxon' do
          assert_equal(child_taxon.base_path, subject[:track_label])
        end
      end
    end
  end

  describe 'topic_grid_section' do
    it 'checks whether topic grid section should be shown' do
      taxon = mock
      taxon.stubs(:child_taxons).returns([])
      taxon_presenter = TaxonPresenter.new(taxon)

      refute taxon_presenter.show_subtopic_grid?
    end
  end

  describe 'organisations' do
    let(:content_hash) { funding_and_finance_for_students_taxon }
    let(:content_item) { ContentItem.new(content_hash) }
    let(:taxon) { Taxon.new(ContentItem.new(content_hash)) }
    let(:taxon_presenter) { TaxonPresenter.new(taxon) }

    it 'checks whether organisations should be shown' do
      TaggedOrganisations.any_instance
        .stubs(:fetch)
        .returns([])

      refute taxon_presenter.show_organisations?
    end

    it 'checks whether more organisations should be shown' do
      TaggedOrganisations.any_instance
        .stubs(:fetch)
        .returns(multiple_organisations_with_logo)

      refute taxon_presenter.show_more_organisations?
    end

    describe '#promoted_organisation_list' do
      it 'returns a list of organisations without logos' do
        TaggedOrganisations.any_instance
          .stubs(:fetch)
          .returns(tagged_organisation)

        promoted_without_logos = [
          {
            link: {
              text: 'Department for Education',
              path: '/government/organisations/department-for-education'
            }
          }
        ]

        expected = {
          "promoted_with_logos": [],
          "promoted_without_logos": promoted_without_logos
        }

        assert_equal expected, taxon_presenter.promoted_organisation_list
      end

      it 'returns a list of organisations with standard logos' do
        TaggedOrganisations.any_instance
          .stubs(:fetch)
          .returns(tagged_organisation_with_logo)

        promoted_with_logos = [
          {
            name: 'Department\nfor\nEducation',
            url: '/government/organisations/department-for-education',
            brand: 'department-for-education',
            crest: 'single-identity'
          }
        ]

        expected = {
          "promoted_with_logos": promoted_with_logos,
          "promoted_without_logos": []
        }

        assert_equal expected, taxon_presenter.promoted_organisation_list
      end

      it 'returns a list of organisations with custom logos as a plain text list' do
        TaggedOrganisations.any_instance
          .stubs(:fetch)
          .returns(tagged_custom_organisation)

        promoted_without_logos = [
          {
            link: {
              text: "Department for Education",
              path: "/government/organisations/department-for-education"
            }
          }
        ]

        expected = {
          "promoted_with_logos": [],
          "promoted_without_logos": promoted_without_logos
        }

        assert_equal expected, taxon_presenter.promoted_organisation_list
      end

      it 'returns top 5 organisations with crests (if available) as promoted organisations' do
        TaggedOrganisations.any_instance
          .stubs(:fetch)
          .returns(multiple_organisations_with_logo("single-identity"))

        promoted_with_logos = []

        5.times do
          promoted_with_logos.push(
            name: 'Department\nfor\nEducation',
            url: '/government/organisations/department-for-education',
            brand: 'department-for-education',
            crest: 'single-identity'
          )
        end

        expected = {
          "promoted_with_logos": promoted_with_logos,
          "promoted_without_logos": []
        }

        assert_equal expected, taxon_presenter.promoted_organisation_list
      end

      it 'returns top 5 organisations without logos as promoted organisations if organisations with logos do not exist' do
        TaggedOrganisations.any_instance
          .stubs(:fetch)
          .returns(multiple_organisations_with_logo)

        promoted_without_logos = []

        5.times do
          promoted_without_logos.push(
            link: {
              text: "Department for Education",
              path: "/government/organisations/department-for-education"
            }
          )
        end

        expected = {
          "promoted_with_logos": [],
          "promoted_without_logos": promoted_without_logos
        }

        assert_equal expected, taxon_presenter.promoted_organisation_list
      end

      it 'returns the organisations with and without logos as promoted content if less than 5 organisations have logos' do
        tagged_organisations = multiple_organisations_with_logo("single-identity", 3) + tagged_organisation

        TaggedOrganisations.any_instance
          .stubs(:fetch)
          .returns(tagged_organisations)

        promoted_with_logos = []

        3.times do
          promoted_with_logos.push(
            name: 'Department\nfor\nEducation',
            url: '/government/organisations/department-for-education',
            brand: 'department-for-education',
            crest: 'single-identity'
          )
        end

        promoted_without_logos = [
          {
            link: {
              text: "Department for Education",
              path: "/government/organisations/department-for-education"
            }
          }
        ]

        expected = {
          "promoted_with_logos": promoted_with_logos,
          "promoted_without_logos": promoted_without_logos
        }

        assert_equal expected, taxon_presenter.promoted_organisation_list
      end
    end

    describe '#show_more_organisation_list' do
      it 'shows a list of more organisations with a logo' do
        tagged_organisations = multiple_organisations_with_logo("single-identity") + tagged_organisation_with_logo

        TaggedOrganisations.any_instance
        .stubs(:fetch)
        .returns(tagged_organisations)

        organisations_with_logos = [
          {
            name: 'Department\nfor\nEducation',
            url: '/government/organisations/department-for-education',
            brand: 'department-for-education',
            crest: 'single-identity'
          }
        ]

        expected = {
          organisations_with_logos: organisations_with_logos,
          organisations_without_logos: []
        }

        assert_equal expected, taxon_presenter.show_more_organisation_list
      end

      it 'shows a list of more organisations without a logo' do
        tagged_organisations = multiple_organisations_with_logo("single-identity") + tagged_organisation

        TaggedOrganisations.any_instance
          .stubs(:fetch)
          .returns(tagged_organisations)

        organisations_without_logos = [
          {
            link: {
              text: 'Department for Education',
              path: '/government/organisations/department-for-education'
            }
          }
        ]

        expected = {
          organisations_with_logos: [],
          organisations_without_logos: organisations_without_logos
        }

        assert_equal expected, taxon_presenter.show_more_organisation_list
      end
    end
  end

  def tagged_organisation
    [
      Organisation.new(
        title: 'Department for Education',
        content_id: 'ebd15ade-73b2-4eaf-b1c3-43034a42eb37',
        link: '/government/organisations/department-for-education',
        slug: 'department-for-education',
        organisation_state: 'live',
        logo_formatted_title: nil,
        brand: nil,
        crest: nil,
        logo_url: nil,
        document_count: 89
      )
    ]
  end

  def tagged_organisation_with_logo
    [
      Organisation.new(
        title: 'Department for Education',
        content_id: 'ebd15ade-73b2-4eaf-b1c3-43034a42eb37',
        link: '/government/organisations/department-for-education',
        slug: 'department-for-education',
        organisation_state: 'live',
        logo_formatted_title: 'Department\nfor\nEducation',
        brand: 'department-for-education',
        crest: 'single-identity',
        logo_url: nil,
        document_count: 89
      )
    ]
  end

  def tagged_custom_organisation
    [
      Organisation.new(
        title: 'Department for Education',
        content_id: 'ebd15ade-73b2-4eaf-b1c3-43034a42eb37',
        link: '/government/organisations/department-for-education',
        slug: 'department-for-education',
        organisation_state: 'live',
        logo_formatted_title: 'Department\nfor\nEducation',
        brand: 'department-for-education',
        crest: 'custom',
        logo_url: '/logo-url.png',
        document_count: 89
      )
    ]
  end

  def multiple_organisations_with_logo(type = nil, number_of_organisations = 5)
    organisations = []

    number_of_organisations.times do
      organisations.push(
        Organisation.new(
          title: 'Department for Education',
          content_id: 'ebd15ade-73b2-4eaf-b1c3-43034a42eb37',
          link: '/government/organisations/department-for-education',
          slug: 'department-for-education',
          organisation_state: 'live',
          logo_formatted_title: 'Department\nfor\nEducation',
          brand: 'department-for-education',
          crest: type,
          logo_url: nil,
          document_count: 89
        )
      )
    end

    organisations
  end
end

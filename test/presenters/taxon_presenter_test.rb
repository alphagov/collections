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

    it 'returns a list of organisations' do
      TaggedOrganisations.any_instance
        .stubs(:fetch)
        .returns(tagged_organisation)

      expected = [
        {
          link: {
            text: 'Department for Education',
            path: '/government/organisations/department-for-education'
          }
        }
      ]

      assert_equal expected, taxon_presenter.organisation_list
    end

    it 'returns a list of organisations with standard logos' do
      TaggedOrganisations.any_instance
        .stubs(:fetch)
        .returns(tagged_organisation_with_logo)

      expected = [
        {
          name: 'Department\nfor\nEducation',
          url: '/government/organisations/department-for-education',
          brand: 'department-for-education',
          crest: 'single-identity'
        }
      ]

      assert_equal expected, taxon_presenter.organisation_list_with_logos
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
        document_count: 89
      )
    ]
  end
end

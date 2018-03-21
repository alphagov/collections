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

      describe 'dimensions' do
        subject { taxon_presenter.options_for_child_taxon(index: 0)[:track_options] }

        describe 'dimension 26 - 1 or 2 (depend if there is leaf grid section or not)' do
          it 'is 2 because there is a leaf grid section' do
            stub_content_for_taxon([taxon.content_id], generate_search_results(15))
            assert_equal('2', subject[:dimension26])
          end

          it 'is 1 because there is no leaf grid section' do
            stub_content_for_taxon([taxon.content_id], generate_search_results(0))
            assert_equal('1', subject[:dimension26])
          end
        end

        describe 'dimension 27 - total number of links on page (incl main and leaf section)' do
          it 'contains the title of tagged content item' do
            stub_content_for_taxon([taxon.content_id], generate_search_results(15))
            assert_equal('16', subject[:dimension27])
          end
        end

        describe 'dimension 28 - number of child taxons' do
          it 'contains the number of child taxons' do
            stub_content_for_taxon([taxon.content_id], generate_search_results(15))
            assert_equal('1', subject[:dimension28])
          end
        end

        describe 'dimension 29 - title of the child taxon' do
          it 'contains the title of tagged content item' do
            stub_content_for_taxon([taxon.content_id], generate_search_results(15))
            assert_equal(child_taxon.title, subject[:dimension29])
          end
        end
      end
    end
  end

  describe 'supergroup_sections' do
    it 'returns a list of supergroup details' do
      taxon = mock
      taxon.stubs(:section_content).returns([])
      taxon.stubs(:base_path)
      taxon_presenter = TaxonPresenter.new(taxon)

      taxon_presenter.sections.each do |section|
        assert_equal(%i(show_section title documents see_more_link), section.keys)
      end
    end
  end

  describe 'guidance_and_regulation_section' do
    it 'checks whether guidance section should be shown' do
      taxon = mock
      taxon.stubs(:section_content).returns([])
      taxon_presenter = TaxonPresenter.new(taxon)

      refute taxon_presenter.show_section?("guidance_and_regulation")
    end

    it 'formats guidance and regulation content for document list' do
      guidance_content = [
        Document.new(
          title: "16 to 19 funding: advanced maths premium",
          description: "The advanced maths premium is funding for additional students",
          public_updated_at: "2018-02-28T08:01:00.000+00:00",
          base_path: "/guidance/16-to-19-funding-advanced-maths-premium",
          content_store_document_type: "detailed_guide"
        )
      ]

      expected = [
        {
          link: {
            text: "16 to 19 funding: advanced maths premium",
            path: "/guidance/16-to-19-funding-advanced-maths-premium"
          },
          metadata: {
            public_updated_at: "2018-02-28T08:01:00.000+00:00",
            document_type: "Detailed guide"
          },
        }
      ]

      taxon = mock
      taxon.stubs(:section_content).returns(guidance_content)
      taxon_presenter = TaxonPresenter.new(taxon)

      assert_equal expected, taxon_presenter.section_document_list("guidance_and_regulation")
    end

    it 'formats the link to the guidance and regulation finder page' do
      taxon = mock
      taxon.stubs(:guidance_and_regulation_content).returns([])
      taxon.stubs(:base_path).returns("/foo")
      taxon_presenter = TaxonPresenter.new(taxon)

      expected_link_details = {
        text: "See all guidance and regulation",
        url: "/search/advanced?group=guidance_and_regulation&topic=%2Ffoo"
      }

      assert_equal expected_link_details, taxon_presenter.section_finder_link("guidance_and_regulation")
    end
  end

  describe 'services_section' do
    it 'formats services content for document list' do
      services_content = [
        Document.new(
          title: 'Register as a schools financial health checks supplier',
          description: 'Register to be added to the directory of schools financial health checks suppliers.',
          public_updated_at: '2018-02-28T08:01:00.000+00:00',
          base_path: '/publications/schools-financial-health-checks-supplier-registration-form',
          content_store_document_type: 'form'
        )
      ]

      expected = [
        {
          link: {
            text: 'Register as a schools financial health checks supplier',
            path: '/publications/schools-financial-health-checks-supplier-registration-form',
            description: 'Register to be added to the directory of schools financial health checks suppliers.',
          }
        }
      ]

      taxon = mock
      taxon.stubs(:section_content).returns(services_content)
      taxon_presenter = TaxonPresenter.new(taxon)

      assert_equal expected, taxon_presenter.section_document_list("services")
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
end

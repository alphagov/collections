require 'test_helper'

include RummagerHelpers
include TaxonHelpers

describe WorldWideTaxonPresenter do
  describe '#rendering_type' do
    it 'returns ACCORDION when the taxon has children, but no grandchildren' do
      taxon = mock
      taxon.stubs(grandchildren?: false, children?: true)

      assert_equal(
        WorldWideTaxonPresenter::ACCORDION,
        WorldWideTaxonPresenter.new(taxon).rendering_type,
        "Expected a taxon with children and no grandchildren to be rendered as an accordion page"
      )
    end

    it 'returns LEAF when the taxon has children and no grandchildren' do
      taxon = mock
      taxon.stubs(grandchildren?: false, children?: false)

      assert_equal(
        WorldWideTaxonPresenter::LEAF,
        WorldWideTaxonPresenter.new(taxon).rendering_type,
        "Expected a taxon without children and grandchildren to be rendered as a leaf page"
      )
    end
  end

  describe 'options' do
    let(:content_hash) { funding_and_finance_for_students_taxon }
    let(:content_item) { ContentItem.new(content_hash) }
    let(:taxon) { Taxon.new(ContentItem.new(content_hash)) }
    let(:child_taxon) { taxon.child_taxons.first }
    let(:world_wide_taxon_presenter) { WorldWideTaxonPresenter.new(taxon) }

    describe '#options_for_leaf_content' do
      before :each do
        @search_results = generate_search_results(15)
        stub_content_for_taxon([taxon.content_id], @search_results)
      end

      describe 'root options' do
        subject { world_wide_taxon_presenter.options_for_leaf_content(index: 10) }

        it 'contains the track-click module' do
          assert_equal('track-click', subject[:module])
        end

        it 'contains the navLeafLinkClicked track_category' do
          assert_equal('navLeafLinkClicked', subject[:track_category])
        end

        it 'contains track-action equal to the index + 1' do
          assert_equal('11', subject[:track_action])
        end

        it 'contains track_label equal to the base path of the content' do
          assert_equal(@search_results[10]['link'], subject[:track_label])
        end
      end

      describe 'dimensions' do
        subject { world_wide_taxon_presenter.options_for_leaf_content(index: 10)[:track_options] }

        describe 'dimension 28 - number of tagged content items' do
          it 'contains the number of tagged content items' do
            assert_equal('15', subject[:dimension28])
          end
        end

        describe 'dimension 29 - title of the tagged content item' do
          it 'contains the title of tagged content item' do
            assert_equal(@search_results[10]['title'], subject[:dimension29])
          end
        end
      end
    end

    describe '#options_for_tagged_content' do
      describe 'root options' do
        before :each do
          @search_results = generate_search_results(15)
          stub_content_for_taxon([taxon.content_id], @search_results)
        end

        subject { world_wide_taxon_presenter.options_for_tagged_content(index: 10) }

        it 'contains the track-click module' do
          assert_equal('track-click', subject[:module])
        end

        it 'contains the navGridContentClicked track_category' do
          assert_equal('navGridContentClicked', subject[:track_category])
        end

        it 'contains track-action equal to the index + 1 prefixed with an L' do
          assert_equal('L11', subject[:track_action])
        end

        it 'contains track_label equal to the base path of the content' do
          assert_equal(@search_results[10]['link'], subject[:track_label])
        end
      end

      describe 'dimensions' do
        before :each do
          @search_results = generate_search_results(15)
          stub_content_for_taxon([taxon.content_id], @search_results)
        end

        subject { world_wide_taxon_presenter.options_for_tagged_content(index: 10)[:track_options] }

        describe 'dimension 26 - "2" (these options by definition have tagged content items)' do
          context 'there is a leaf grid section' do
            it 'is 2' do
              assert_equal('2', subject[:dimension26])
            end
          end
        end

        describe 'dimension 27 - total number of links on page (incl main and leaf section)' do
          it 'contains the title of tagged content item' do
            assert_equal('16', subject[:dimension27])
          end
        end

        describe 'dimension 28 - number of tagged content items' do
          it 'contains the number of tagged content items' do
            assert_equal('15', subject[:dimension28])
          end
        end

        describe 'dimension 29 - title of the tagged content item' do
          it 'contains the title of tagged content item' do
            assert_equal(@search_results[10]['title'], subject[:dimension29])
          end
        end
      end
    end

    describe '#options_for_child_taxon' do
      describe 'root options' do
        before :each do
          stub_content_for_taxon([taxon.content_id], generate_search_results(15))
        end

        subject { world_wide_taxon_presenter.options_for_child_taxon(index: 0) }

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
        subject { world_wide_taxon_presenter.options_for_child_taxon(index: 0)[:track_options] }

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
end

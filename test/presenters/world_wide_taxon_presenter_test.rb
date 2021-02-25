require "test_helper"

describe WorldWideTaxonPresenter do
  include SearchApiHelpers
  include TaxonHelpers

  describe "#rendering_type" do
    it "returns ACCORDION when the taxon has children, but no grandchildren" do
      taxon = mock
      taxon.stubs(grandchildren?: false, children?: true)

      assert_equal(
        WorldWideTaxonPresenter::ACCORDION,
        WorldWideTaxonPresenter.new(taxon).rendering_type,
        "Expected a taxon with children and no grandchildren to be rendered as an accordion page",
      )
    end

    it "returns LEAF when the taxon has children and no grandchildren" do
      taxon = mock
      taxon.stubs(grandchildren?: false, children?: false)

      assert_equal(
        WorldWideTaxonPresenter::LEAF,
        WorldWideTaxonPresenter.new(taxon).rendering_type,
        "Expected a taxon without children and grandchildren to be rendered as a leaf page",
      )
    end
  end

  describe "options" do
    let(:content_hash) { funding_and_finance_for_students_taxon }
    let(:content_item) { ContentItem.new(content_hash) }
    let(:taxon) { WorldWideTaxon.new(ContentItem.new(content_hash)) }
    let(:child_taxon) { taxon.child_taxons.first }
    let(:world_wide_taxon_presenter) { WorldWideTaxonPresenter.new(taxon) }

    describe "#options_for_leaf_content" do
      before :each do
        @search_results = generate_search_results(15)
        stub_content_for_taxon([taxon.content_id], @search_results)
      end

      describe "root options" do
        subject { world_wide_taxon_presenter.options_for_leaf_content(index: 10) }

        it "contains the gem-track-click module" do
          assert_equal("gem-track-click", subject[:module])
        end

        it "contains the navLeafLinkClicked track_category" do
          assert_equal("navLeafLinkClicked", subject[:track_category])
        end

        it "contains track-action equal to the index + 1" do
          assert_equal("11", subject[:track_action])
        end

        it "contains track_label equal to the base path of the content" do
          assert_equal(@search_results[10]["link"], subject[:track_label])
        end
      end

      describe "dimensions" do
        subject { world_wide_taxon_presenter.options_for_leaf_content(index: 10)[:track_options] }

        describe "dimension 28 - number of tagged content items" do
          it "contains the number of tagged content items" do
            assert_equal("15", subject[:dimension28])
          end
        end

        describe "dimension 29 - title of the tagged content item" do
          it "contains the title of tagged content item" do
            assert_equal(@search_results[10]["title"], subject[:dimension29])
          end
        end
      end
    end
  end
end

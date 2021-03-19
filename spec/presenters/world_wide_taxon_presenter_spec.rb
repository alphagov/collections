RSpec.describe WorldWideTaxonPresenter do
  include SearchApiHelpers
  include TaxonHelpers

  describe "#rendering_type" do
    it "returns ACCORDION when the taxon has children, but no grandchildren" do
      taxon = double("Taxon", grandchildren?: false, children?: true)

      expect(WorldWideTaxonPresenter.new(taxon).rendering_type).to eq(WorldWideTaxonPresenter::ACCORDION)
    end

    it "returns LEAF when the taxon has children and no grandchildren" do
      taxon = double("Taxon", grandchildren?: false, children?: false)

      expect(WorldWideTaxonPresenter.new(taxon).rendering_type).to eq(WorldWideTaxonPresenter::LEAF)
    end
  end

  describe "options_options_for_leaf_content" do
    let(:content_hash) { funding_and_finance_for_students_taxon }
    let(:content_item) { ContentItem.new(content_hash) }
    let(:taxon) { WorldWideTaxon.new(ContentItem.new(content_hash)) }
    let(:child_taxon) { taxon.child_taxons.first }
    let(:world_wide_taxon_presenter) { WorldWideTaxonPresenter.new(taxon) }
    let(:search_results) { generate_search_results(15) }

    before do
      stub_content_for_taxon([taxon.content_id], search_results)
    end

    describe "root options" do
      subject { world_wide_taxon_presenter.options_for_leaf_content(index: 10) }

      it "contains the gem-track-click module" do
        expect(subject[:module]).to eq("gem-track-click")
      end

      it "contains the navLeafLinkClicked track_category" do
        expect(subject[:track_category]).to eq("navLeafLinkClicked")
      end

      it "contains track-action equal to the index + 1" do
        expect(subject[:track_action]).to eq("11")
      end

      it "contains track_label equal to the base path of the content" do
        expect(subject[:track_label]).to eq(search_results[10]["link"])
      end
    end

    describe "dimensions" do
      subject { world_wide_taxon_presenter.options_for_leaf_content(index: 10)[:track_options] }

      describe "dimension 28 - number of tagged content items" do
        it "contains the number of tagged content items" do
          expect(subject[:dimension28]).to eq("15")
        end
      end

      describe "dimension 29 - title of the tagged content item" do
        it "contains the title of tagged content item" do
          expect(subject[:dimension29]).to eq(search_results[10]["title"])
        end
      end
    end
  end
end

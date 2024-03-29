RSpec.describe TaxonPresenter do
  include SearchApiHelpers
  include TaxonHelpers

  describe "options" do
    let(:content_hash) { funding_and_finance_for_students_taxon }
    let(:content_item) { ContentItem.new(content_hash) }
    let(:taxon) { Taxon.new(ContentItem.new(content_hash)) }
    let(:child_taxon) { taxon.child_taxons.first }
    let(:taxon_presenter) { TaxonPresenter.new(taxon) }

    describe "#options_for_child_taxon" do
      describe "root options" do
        before do
          allow(taxon_presenter).to receive(:page_section_total).and_return(nil)
          stub_content_for_taxon([taxon.content_id], generate_search_results(15))
        end

        subject { taxon_presenter.options_for_child_taxon(index: 0) }

        it "contains the gem-track-click module" do
          expect(subject[:module]).to eq("gem-track-click")
        end

        it "contains the navGridContentClicked track_category" do
          expect(subject[:track_category]).to eq("navGridContentClicked")
        end

        it "contains track-action equal to the index + 1" do
          expect(subject[:track_action]).to eq("1")
        end

        it "contains track_label equal to the base path of the child taxon" do
          expect(subject[:track_label]).to eq(child_taxon.base_path)
        end
      end
    end
  end

  describe "topic_grid_section" do
    it "checks whether topic grid section should be shown" do
      taxon = double("Taxon", child_taxons: [])
      taxon_presenter = TaxonPresenter.new(taxon)

      expect(taxon_presenter.show_subtopic_grid?).to be false
    end
  end
end

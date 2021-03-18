require "test_helper"

describe TaxonPresenter do
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
        before :each do
          stub_content_for_taxon([taxon.content_id], generate_search_results(15))
        end

        subject { taxon_presenter.options_for_child_taxon(index: 0) }

        it "contains the gem-track-click module" do
          assert_equal("gem-track-click", subject[:module])
        end

        it "contains the navGridContentClicked track_category" do
          assert_equal("navGridContentClicked", subject[:track_category])
        end

        it "contains track-action equal to the index + 1" do
          assert_equal("1", subject[:track_action])
        end

        it "contains track_label equal to the base path of the child taxon" do
          assert_equal(child_taxon.base_path, subject[:track_label])
        end
      end
    end
  end

  describe "topic_grid_section" do
    it "checks whether topic grid section should be shown" do
      taxon = mock
      taxon.stubs(:child_taxons).returns([])
      taxon_presenter = TaxonPresenter.new(taxon)

      assert_not taxon_presenter.show_subtopic_grid?
    end
  end

  describe "noindex" do
    let(:content_hash) { funding_and_finance_for_students_taxon }
    let(:content_item) { ContentItem.new(content_hash) }
    let(:taxon) { Taxon.new(ContentItem.new(content_hash)) }
    let(:taxon_presenter) { TaxonPresenter.new(taxon) }

    it "returns true by default" do
      assert taxon_presenter.noindex?
    end

    context "when it is a brexit taxon" do
      let(:content_hash) do
        funding_and_finance_for_students_taxon.merge("content_id" => "d6c2de5d-ef90-45d1-82d4-5f2438369eea")
      end

      it "returns false" do
        assert_not taxon_presenter.noindex?
      end
    end
  end
end

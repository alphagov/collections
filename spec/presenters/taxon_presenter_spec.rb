RSpec.describe TaxonPresenter do
  include SearchApiHelpers
  include TaxonHelpers

  describe "topic_grid_section" do
    it "checks whether topic grid section should be shown" do
      taxon = double("Taxon", child_taxons: [])
      taxon_presenter = TaxonPresenter.new(taxon)

      expect(taxon_presenter.show_subtopic_grid?).to be false
    end
  end
end

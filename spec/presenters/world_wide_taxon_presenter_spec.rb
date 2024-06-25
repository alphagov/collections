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
end

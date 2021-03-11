RSpec.describe WorldTaxonomySorter do
  class FakeTaxon
    attr_reader :title

    def initialize(title)
      @title = title
    end
  end

  before do
    child_taxon_titles = [
      "Birth, death and marriage abroad",
      "Transition",
      "British embassy or high commission",
      "Coming to the UK",
      "Emergency help for British nationals",
      "News and events",
      "Passports and emergency travel documents",
      "Living in",
      "Tax, benefits, pensions and working abroad",
      "Trade and invest",
      "Travelling to",
    ]
    @child_taxons = child_taxon_titles.map { |title| FakeTaxon.new(title) }

    @expected_ordered_taxon_titles = [
      "Emergency help for British nationals",
      "Transition",
      "Passports and emergency travel documents",
      "Travelling to",
      "Coming to the UK",
      "Living in",
      "Tax, benefits, pensions and working abroad",
      "Birth, death and marriage abroad",
      "News and events",
      "Trade and invest",
      "British embassy or high commission",
    ]
  end

  describe "#call" do
    it "sorts the given child taxons by the specified sorting order" do
      sorted_child_taxon_titles = WorldTaxonomySorter.call(@child_taxons).map(&:title)

      expect(sorted_child_taxon_titles).to eq(@expected_ordered_taxon_titles)
    end

    it "appends any child taxons which did not match to a title in the specified sorting order" do
      child_taxons = @child_taxons.concat(
        [
          FakeTaxon.new("Another taxon"),
          FakeTaxon.new("And another taxon"),
        ],
      )

      expected_ordered_taxon_titles = @expected_ordered_taxon_titles.concat(
        [
          "Another taxon",
          "And another taxon",
        ],
      )

      sorted_child_taxon_titles = WorldTaxonomySorter.call(child_taxons).map(&:title)

      expect(sorted_child_taxon_titles).to eq(expected_ordered_taxon_titles)
    end
  end
end

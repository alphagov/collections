RSpec.describe TablePresenter do
  let(:table_data) do
    {
      headings: %w[
        Date
        Country
      ],
      rows: [
        [
          "21/09/2020",
          "Belgium",
        ],
        [
          "23/09/2020",
          "France",
        ],
      ],
    }
  end

  subject { described_class.new(table_data) }

  describe "#rows" do
    it "returns formatted table rows" do
      output =
        [
          [
            { text: "21/09/2020" },
            { text: "Belgium" },
          ],
          [
            { text: "23/09/2020" },
            { text: "France" },
          ],
        ]
      expect(output).to eq(subject.rows)
    end
  end

  describe "#headings" do
    it "returns a formatted header row" do
      output = [{ text: "Date" }, { text: "Country" }]
      expect(output).to eq(subject.headings)
    end
  end

  context "with invalid input" do
    it "returns nil if required keys aren't present" do
      table_data = { foo: [], bar: [] }
      presenter = described_class.new(table_data)
      expect(presenter.headings).to be_nil
      expect(presenter.rows).to be_nil
    end

    it "returns nil if row data is not an array of arrays" do
      table_data = {
        headings: %w[Date Country],
        rows: ["21/09/2020", "Belgium", "23/09/2020", "France"],
      }
      presenter = described_class.new(table_data)
      expect(presenter.headings).to be_nil
      expect(presenter.rows).to be_nil
    end
  end
end

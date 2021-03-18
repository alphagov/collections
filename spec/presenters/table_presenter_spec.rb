require "test_helper"

describe TablePresenter do
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
      assert_equal(subject.rows, output)
    end
  end

  describe "#headings" do
    it "returns a formatted header row" do
      output = [{ text: "Date" }, { text: "Country" }]
      assert_equal(subject.headings, output)
    end
  end

  context "with invalid input" do
    it "returns nil if required keys aren't present" do
      table_data = { foo: [], bar: [] }
      presenter = described_class.new(table_data)
      assert_nil(presenter.headings)
      assert_nil(presenter.rows)
    end

    it "returns nil if row data is not an array of arrays" do
      table_data = {
        headings: %w[Date Country],
        rows: ["21/09/2020", "Belgium", "23/09/2020", "France"],
      }
      presenter = described_class.new(table_data)
      assert_nil(presenter.headings)
      assert_nil(presenter.rows)
    end
  end
end

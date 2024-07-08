RSpec.describe MinistersIndexPresenter do
  let(:ministers_index) do
    content_item = double("content item", details:, content_item_data:)
    double("ministers_index", content_item:)
  end
  let(:details) do
    {
      "body" => "Foo",
      "reshuffle" => nil,
    }
  end
  let(:content_item_data) { { "links" => {} } }

  describe "#cabinet_ministers" do
    it "defaults to empty array if no ordered_cabinet_ministers provided" do
      presenter = MinistersIndexPresenter.new(ministers_index)
      expect(presenter.cabinet_ministers).to eq([])
    end

    context "ordered_cabinet_ministers is provided" do
      let(:content_item_data) do
        {
          "links" => {
            "ordered_cabinet_ministers" => [{ "foo" => "bar" }],
          },
        }
      end

      it "returns array of ministers" do
        stubbed_minister = double("MinistersIndexPresenter::Minister")
        allow(MinistersIndexPresenter::Minister).to receive(:new).and_return(stubbed_minister)

        presenter = MinistersIndexPresenter.new(ministers_index)
        expect(presenter.cabinet_ministers).to eq([stubbed_minister])
      end
    end
  end

  describe "#also_attends_cabinet" do
    it "defaults to empty array if no ordered_also_attends_cabinet provided" do
      presenter = MinistersIndexPresenter.new(ministers_index)
      expect(presenter.also_attends_cabinet).to eq([])
    end

    context "ordered_also_attends_cabinet is provided" do
      let(:content_item_data) do
        {
          "links" => {
            "ordered_also_attends_cabinet" => [{ "foo" => "bar" }],
          },
        }
      end

      it "returns array of ministers" do
        stubbed_minister = double("MinistersIndexPresenter::Minister")
        allow(MinistersIndexPresenter::Minister).to receive(:new).and_return(stubbed_minister)

        presenter = MinistersIndexPresenter.new(ministers_index)
        expect(presenter.also_attends_cabinet).to eq([stubbed_minister])
      end
    end
  end

  describe "#by_organisation" do
    it "defaults to empty array if no ordered_ministerial_departments provided" do
      presenter = MinistersIndexPresenter.new(ministers_index)
      expect(presenter.by_organisation).to eq([])
    end

    context "ordered_ministerial_departments is provided" do
      let(:content_item_data) do
        {
          "links" => {
            "ordered_ministerial_departments" => [
              {
                "web_url" => "foo",
                "title" => "foo",
                "details" => {
                  "brand" => "foo",
                  "logo" => {
                    "crest" => "foo",
                    "formatted_title" => "foo",
                  },
                },
                "links" => ordered_ministerial_departments_links,
              },
            ],
          },
        }
      end
      let(:ordered_ministerial_departments_links) do
        {
          "ordered_ministers" => [{ "foo" => "bar" }],
        }
      end

      it "returns array of departments" do
        stubbed_department = double("MinistersIndexPresenter::Department")
        allow(MinistersIndexPresenter::Department).to receive(:new).and_return(stubbed_department)

        presenter = MinistersIndexPresenter.new(ministers_index)
        expect(presenter.by_organisation).to eq([stubbed_department])
      end

      it "returns ministers associated with departments" do
        stubbed_minister = double("MinistersIndexPresenter::Minister")
        allow(MinistersIndexPresenter::Minister).to receive(:new).and_return(stubbed_minister)
        stubbed_department = double("MinistersIndexPresenter::Department", ministers: [stubbed_minister])
        allow(MinistersIndexPresenter::Department).to receive(:new).and_return(stubbed_department)

        presenter = MinistersIndexPresenter.new(ministers_index)
        expect(presenter.by_organisation.first.ministers).to eq([stubbed_minister])
      end

      context "no ministers specified for the department" do
        let(:ordered_ministerial_departments_links) { {} }

        it "has departments' ministers defaulting to empty array" do
          allow_any_instance_of(MinistersIndexPresenter::Department).to receive(:ministers).and_call_original

          presenter = MinistersIndexPresenter.new(ministers_index)
          expect(presenter.by_organisation.first.ministers).to eq([])
        end
      end
    end
  end

  # TODO: add tests for MinistersIndexPresenter::Minister class
end

RSpec.describe MinistersIndexPresenter do
  let(:content_item_data) { { "links" => {} } }

  describe "#cabinet_ministers" do
    it "defaults to empty array if no ordered_cabinet_ministers provided" do
      presenter = MinistersIndexPresenter.new(content_item_data)
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

        presenter = MinistersIndexPresenter.new(content_item_data)
        expect(presenter.cabinet_ministers).to eq([stubbed_minister])
      end
    end
  end

  describe "#also_attends_cabinet" do
    it "defaults to empty array if no ordered_also_attends_cabinet provided" do
      presenter = MinistersIndexPresenter.new(content_item_data)
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

        presenter = MinistersIndexPresenter.new(content_item_data)
        expect(presenter.also_attends_cabinet).to eq([stubbed_minister])
      end
    end
  end

  describe "#by_organisation" do
    it "defaults to empty array if no ordered_ministerial_departments provided" do
      presenter = MinistersIndexPresenter.new(content_item_data)
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

        presenter = MinistersIndexPresenter.new(content_item_data)
        expect(presenter.by_organisation).to eq([stubbed_department])
      end

      it "returns ministers associated with departments" do
        stubbed_minister = double("MinistersIndexPresenter::Minister")
        allow(MinistersIndexPresenter::Minister).to receive(:new).and_return(stubbed_minister)
        stubbed_department = double("MinistersIndexPresenter::Department", ministers: [stubbed_minister])
        allow(MinistersIndexPresenter::Department).to receive(:new).and_return(stubbed_department)

        presenter = MinistersIndexPresenter.new(content_item_data)
        expect(presenter.by_organisation.first.ministers).to eq([stubbed_minister])
      end

      context "no ministers specified for the department" do
        let(:ordered_ministerial_departments_links) { {} }

        it "has departments' ministers defaulting to empty array" do
          allow_any_instance_of(MinistersIndexPresenter::Department).to receive(:ministers).and_call_original

          presenter = MinistersIndexPresenter.new(content_item_data)
          expect(presenter.by_organisation.first.ministers).to eq([])
        end
      end
    end
  end

  describe "#whips" do
    let(:content_item_data) do
      {
        "links" => {
          "ordered_junior_lords_of_the_treasury_whips" => [
            {
              "name" => "Person 1",
              "links" => {
                "role_appointments" => [
                  {
                    "details" => {
                      "current" => true,
                    },
                    "links" => {
                      "role" => [
                        {
                          "content_id" => "01d57ccd-ef0d-4a28-b638-eab2cc06ffe9",
                          "title" => "Whip role",
                          "web_url" => "https://www.integration.publishing.service.gov.uk/government/ministers/whip-role",
                          "details" => {
                            "seniority" => 109,
                            "whip_organisation" => {
                              "label" => "Junior Lords of the Treasury",
                              "sort_order" => 2,
                            },
                          },
                        },
                      ],
                    },
                  },
                  {
                    "details" => {
                      "current" => true,
                    },
                    "links" => {
                      "role" => [
                        {
                          "content_id" => "d301319d-5957-4fec-acbc-1dfef3f79267",
                          "title" => "Another role",
                          "web_url" => "https://www.integration.publishing.service.gov.uk/government/ministers/role",
                          "details" => {
                            "seniority" => 100,
                            "whip_organisation" => non_whip_role_organisation,
                          },
                        },
                      ],
                    },
                  },
                ],
              },
            },
          ],
        },
      }
    end

    let(:expected_roles) do
      [
        MinistersIndexPresenter::Minister::Role.new(
          id: "01d57ccd-ef0d-4a28-b638-eab2cc06ffe9",
          payment_info: nil,
          seniority: 109,
          title: "Whip role",
          url: "https://www.integration.publishing.service.gov.uk/government/ministers/whip-role",
          whip: true,
        ),
      ]
    end

    context "when the response is from Content Store" do
      let(:non_whip_role_organisation) { {} }

      it "returns people with only their whip roles" do
        presenter = MinistersIndexPresenter.new(content_item_data)
        expect(
          presenter.whips.find { |whip_types| whip_types.item_key == "ordered_junior_lords_of_the_treasury_whips" }.ministers.first.roles,
        ).to eq(expected_roles)
      end
    end

    context "when the response is from GraphQL" do
      let(:non_whip_role_organisation) do
        {
          "label" => nil,
          "sort_order" => nil,
        }
      end

      it "returns people with only their whip roles" do
        presenter = MinistersIndexPresenter.new(content_item_data)
        expect(
          presenter.whips.find { |whip_types| whip_types.item_key == "ordered_junior_lords_of_the_treasury_whips" }.ministers.first.roles,
        ).to eq(expected_roles)
      end
    end
  end

  # TODO: add tests for MinistersIndexPresenter::Minister class
end

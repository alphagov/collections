module CoronavirusContentItemHelper
  CORONAVIRUS_TAXON_PATH = "/coronavirus-taxons".freeze

  def coronavirus_landing_page_content_item
    load_content_item("coronavirus_landing_page.json")
  end

  def load_content_item(file_name)
    json = File.read(
      Rails.root.join("spec/fixtures/content_store/", file_name),
    )
    JSON.parse(json)
  end

  def stub_coronavirus_statistics
    body = {
      data: [
        {
          "date" => "2021-03-18",
          "cumulativeFirstDoseVaccinations" => nil,
          "cumulativeSecondDoseVaccinations" => nil,
          "percentageFirstVaccine" => nil,
          "percentageSecondVaccine" => nil,
          "hospitalAdmissions" => nil,
          "newPositiveTests" => nil,
        },
        {
          "date" => "2021-03-17",
          "cumulativeFirstDoseVaccinations" => 25_735_472,
          "cumulativeSecondDoseVaccinations" => 20_735_472,
          "percentageFirstVaccine" => 86,
          "percentageSecondVaccine" => 54,
          "hospitalAdmissions" => nil,
          "newPositiveTests" => 5758,
        },
        {
          "date" => "2021-03-16",
          "cumulativeFirstDoseVaccinations" => 25_273_226,
          "cumulativeSecondDoseVaccinations" => 20_273_226,
          "percentageFirstVaccine" => 80,
          "percentageSecondVaccine" => 50,
          "hospitalAdmissions" => nil,
          "newPositiveTests" => 5294,
        },
        {
          "date" => "2021-03-15",
          "cumulativeFirstDoseVaccinations" => 24_839_906,
          "cumulativeSecondDoseVaccinations" => 19_839_906,
          "percentageFirstVaccine" => 74,
          "percentageSecondVaccine" => 44,
          "hospitalAdmissions" => nil,
          "newPositiveTests" => 5089,
        },
        {
          "date" => "2021-03-14",
          "cumulativeFirstDoseVaccinations" => 24_453_221,
          "cumulativeSecondDoseVaccinations" => 19_453_221,
          "percentageFirstVaccine" => 69,
          "percentageSecondVaccine" => 39,
          "hospitalAdmissions" => 426,
          "newPositiveTests" => 4618,
        },
        {
          "date" => "2021-03-13",
          "cumulativeFirstDoseVaccinations" => 24_196_211,
          "cumulativeSecondDoseVaccinations" => 19_196_211,
          "percentageFirstVaccine" => 62,
          "percentageSecondVaccine" => 32,
          "hospitalAdmissions" => 460,
          "newPositiveTests" => 5534,
        },
        {
          "date" => "2021-03-12",
          "cumulativeFirstDoseVaccinations" => 20_196_211,
          "cumulativeSecondDoseVaccinations" => 15_196_211,
          "percentageFirstVaccine" => 52,
          "percentageSecondVaccine" => 22,
          "hospitalAdmissions" => 300,
          "newPositiveTests" => 6534,
        },
        {
          "date" => "2021-03-11",
          "cumulativeFirstDoseVaccinations" => 18_196_211,
          "cumulativeSecondDoseVaccinations" => 9_196_211,
          "percentageFirstVaccine" => 62,
          "percentageSecondVaccine" => 32,
          "hospitalAdmissions" => 500,
          "newPositiveTests" => 5034,
        },
        {
          "date" => "2021-03-10",
          "cumulativeFirstDoseVaccinations" => 18_196_211,
          "cumulativeSecondDoseVaccinations" => 9_196_211,
          "percentageFirstVaccine" => 62,
          "percentageSecondVaccine" => 32,
          "hospitalAdmissions" => 500,
          "newPositiveTests" => 5033,
        },
        {
          "date" => "2021-03-09",
          "cumulativeFirstDoseVaccinations" => 18_196_211,
          "cumulativeSecondDoseVaccinations" => 9_196_211,
          "percentageFirstVaccine" => 62,
          "percentageSecondVaccine" => 32,
          "hospitalAdmissions" => 500,
          "newPositiveTests" => 5032,
        },
        {
          "date" => "2021-03-08",
          "cumulativeFirstDoseVaccinations" => 18_196_211,
          "cumulativeSecondDoseVaccinations" => 9_196_211,
          "percentageFirstVaccine" => 62,
          "percentageSecondVaccine" => 32,
          "hospitalAdmissions" => 500,
          "newPositiveTests" => 5031,
        },
        {
          "date" => "2021-03-07",
          "cumulativeFirstDoseVaccinations" => 18_196_211,
          "cumulativeSecondDoseVaccinations" => 9_196_211,
          "percentageFirstVaccine" => 62,
          "percentageSecondVaccine" => 32,
          "hospitalAdmissions" => 500,
          "newPositiveTests" => 5030,
        },
        {
          "date" => "2021-03-06",
          "cumulativeFirstDoseVaccinations" => 18_196_211,
          "cumulativeSecondDoseVaccinations" => 9_196_211,
          "percentageFirstVaccine" => 62,
          "percentageSecondVaccine" => 32,
          "hospitalAdmissions" => 500,
          "newPositiveTests" => 5029,
        },
        {
          "date" => "2021-03-05",
          "cumulativeFirstDoseVaccinations" => 18_196_211,
          "cumulativeSecondDoseVaccinations" => 9_196_211,
          "percentageFirstVaccine" => 62,
          "percentageSecondVaccine" => 32,
          "hospitalAdmissions" => 500,
          "newPositiveTests" => 5028,
        },
        {
          "date" => "2021-03-04",
          "cumulativeFirstDoseVaccinations" => 18_196_211,
          "cumulativeSecondDoseVaccinations" => 9_196_211,
          "percentageFirstVaccine" => 62,
          "percentageSecondVaccine" => 32,
          "hospitalAdmissions" => 500,
          "newPositiveTests" => 5027,
        },
      ],
    }

    stub_request(:get, /coronavirus.data.gov.uk/).to_return(status: 200, body: body.to_json)
  end

  def random_landing_page(&block)
    GovukSchemas::RandomExample.for_schema(frontend_schema: "coronavirus_landing_page", &block)
  end

  def coronavirus_content_item
    random_landing_page do |item|
      item.merge(coronavirus_landing_page_content_item)
    end
  end

  def coronavirus_content_item_with_risk_level_element_enabled
    content_item = coronavirus_content_item
    content_item["details"]["risk_level"]["show_risk_level_section"] = true
    content_item
  end

  def coronavirus_content_item_with_timeline_national_applicability_without_wales
    load_content_item("coronavirus_landing_page_with_timeline_nations_without_wales.json")
  end

  def random_taxon_page
    GovukSchemas::RandomExample.for_schema(frontend_schema: "taxon") do |item|
      yield(item) if block_given?
      item["phase"] = "live"
      item
    end
  end

  def other_subtaxon_item
    random_linked_taxon = random_taxon_page do |item|
      item["links"] = {}
    end

    random_taxon_page do |item|
      item["links"]["parent_taxons"] = [random_linked_taxon]
      item
    end
  end
end

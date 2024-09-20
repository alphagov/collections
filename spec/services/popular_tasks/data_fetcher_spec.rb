RSpec.describe PopularTasks::DataFetcher do
  let(:google_client) { instance_double(Google::Cloud::Bigquery::Project) }
  let(:results) { instance_double(Google::Cloud::Bigquery::Data) }
  let(:sql) do
    <<~SQL
      WITH CTE1 AS (
        SELECT *
        FROM `ga4-analytics-352613.browse-popular-tasks.#{browse_page}_*`
        WHERE _TABLE_SUFFIX = FORMAT_DATE('%Y%m%d', raw_date)
      )
      SELECT
        page_title AS title,
        link_url AS link,
        rank AS rank
      FROM CTE1
    SQL
  end
  let(:data) do
    [
      { "page_title" => "Foo", "link_url" => "/foo", "rank" => 1 },
      { "page_title" => "Bar", "link_url" => "/bar", "rank" => 2 },
      { "page_title" => "Cool", "link_url" => "/cool", "rank" => 3 },
    ]
  end

  before do
    allow(PopularTasks::Bigquery).to receive(:build).and_return(google_client)
    allow(google_client).to receive(:query).with(sql).and_return(results)
    allow(results).to receive(:all).and_return(:data)
  end

  it "#popular_task_data" do
    results = described_class.new.popular_task_data("/browse/benefits", "01-09-2024")
    expect(results).to eq data
  end
end

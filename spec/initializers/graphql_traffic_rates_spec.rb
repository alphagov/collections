RSpec.describe "graphql_traffic_rates initializer" do
  let(:initializer_path) { Rails.root.join("config/initializers/graphql_traffic_rates.rb") }

  around do |example|
    ClimateControl.modify(
      "GRAPHQL_RATE_FIRST_SCHEMA": "0.25",
      "GRAPHQL_RATE_SECOND_SCHEMA": "0.75",
    ) do
      example.run
    end
  end

  it "populates Rails.application.config.graphql_traffic_rates from ENV" do
    load initializer_path

    expect(Rails.application.config.graphql_traffic_rates).to eq(
      {
        "first_schema" => 0.25,
        "second_schema" => 0.75,
      },
    )
  end
end

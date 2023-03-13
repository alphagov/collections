class PastChancellorsController < ApplicationController
  def index
    setup_content_item_and_navigation_helpers(HistoricAppointmentsIndex.find!(request.path))

    yaml_content_item = YAML.load_file(Rails.root.join("config/past_chancellors/content_item.yml")).deep_symbolize_keys
    @presenter = PastHistoricalFiguresPresenter.new(yaml_content_item)
  end
end

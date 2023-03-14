class PastChancellorsController < ApplicationController
  def index
    setup_content_item_and_navigation_helpers(HistoricAppointmentsIndex.find!(request.path))

    yaml_content_item = YAML.load_file(Rails.root.join("config/past_chancellors/content_item.yml"))
    @content_item = HistoricAppointmentsIndex.new(ContentItem.new(yaml_content_item))
  end
end

class PastForeignSecretariesController < ApplicationController
  def index
    setup_content_item_and_navigation_helpers(HistoricAppointmentsIndex.find!(request.path))

    yaml_content_item = YAML.load_file(Rails.root.join("config/past_foreign_secretaries/content_item.yml"))
    @content_item = HistoricAppointmentsIndex.new(ContentItem.new(yaml_content_item))
  end

  def show
    setup_content_item_and_navigation_helpers(HistoricAppointmentsIndex.find!(request.path.split("/")[0...-1].join("/")))

    if people_with_individual_pages.include?(params[:id])
      render template: "past_foreign_secretaries/#{params[:id].underscore}"
    else
      render plain: "Not found", status: :not_found
    end
  end

private

  def people_with_individual_pages
    %w[
      austen-chamberlain
      charles-fox
      edward-grey
      edward-wood
      george-curzon
      george-gordon
      george-gower
      henry-petty-fitzmaurice
      robert-cecil
      william-grenville
    ]
  end
end

class HistoricAppointmentsController < ApplicationController
  def index
    @index_page = HistoricAppointmentsIndex.find!(request.path)
    @presenter = HistoricAppointmentsIndexPresenter.new(@index_page)
    setup_content_item_and_navigation_helpers(@index_page)
  end

  def show
    setup_content_item_and_navigation_helpers(HistoricAppointmentsIndex.find!(request.path))

    if foreign_secretaries_with_individual_pages.include?(params[:id])
      render template: "historic_appointments/past_foreign_secretaries/#{params[:id].underscore}"
    else
      render plain: "Not found", status: :not_found
    end
  end

private

  def foreign_secretaries_with_individual_pages
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

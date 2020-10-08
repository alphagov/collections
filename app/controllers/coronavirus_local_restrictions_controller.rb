class CoronavirusLocalRestrictionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:results]

  def show
    render :show,
           locals: {
             breadcrumbs: breadcrumbs,
           }
  end

  def results
    @postcode = params["postcode-lookup"].gsub(/\s+/, "").upcase
  end

  def error_404
    super
  end

private

  # Breadcrumbs for this page are hardcoded because it doesn't yet have a
  # content item with parents.
  def breadcrumbs
    [
      {
        title: "Home",
        url: "/",
      },
      {
        title: "Coronavirus (COVID-19)",
        url: "/coronavirus",
      },
    ]
  end
end

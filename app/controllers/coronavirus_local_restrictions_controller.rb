class CoronavirusLocalRestrictionsController < ApplicationController
  def show
    render :show,
           locals: {
             breadcrumbs: breadcrumbs,
           }
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

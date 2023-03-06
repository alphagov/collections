class DevelopmentController < ApplicationController
  layout false

  def index
    @schema_names = %w[
      coronavirus_landing_page
      finder
      historic_appointment
      mainstream_browse_page
      ministerial_role
      organisation
      person
      services_and_information
      step_by_step_nav
      taxon
      topic
      topical_event
      world_location_news
    ]

    @paths = YAML.load_file(Rails.root.join("config/govuk_examples.yml"))
  end
end

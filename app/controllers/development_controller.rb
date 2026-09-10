class DevelopmentController < ApplicationController
  layout false

  def index
    @schema_names = %w[
      coronavirus_landing_page
      embassies
      embassy
      finder
      government_feed
      historic_appointment
      mainstream_browse_page
      ministerial_role
      organisation
      organisation_feed
      past_prime_ministers
      step_by_step_nav
      taxon
      topical_event
      world_embassies
      world_location_news
      world_wide_taxon
    ]

    @paths = YAML.load_file(Rails.root.join("config/govuk_examples.yml"))
  end
end

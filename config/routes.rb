Rails.application.routes.draw do
  # Note that this app only receives requests for routes registered with the
  # content-store (by collections-publisher) - whenever the routes below
  # change, also change the routes claimed by collections-publisher.

  mount GovukPublishingComponents::Engine, at: "/component-guide"

  get "/healthcheck",
      to: GovukHealthcheck.rack_response(
        GovukHealthcheck::RailsCache,
      )

  ["/coronavirus-taxon", "/coronavirus-taxon/*slug"].each do |path|
    get path, to: "taxons_redirection#redirect"
  end

  get "/coronavirus", to: "coronavirus_landing_page#show", as: :coronavirus_landing_page
  get "/coronavirus/:hub_slug", to: "coronavirus_landing_page#hub"
  get "/eubusiness", to: "dit_landing_page#show"
  get "/browse.json" => redirect("/api/content/browse")

  resources :browse, only: %i[index show], param: :top_level_slug do
    get ":second_level_slug", on: :member, to: "second_level_browse_page#show"
  end

  resources :topics, only: %i[index show], path: :topic, param: :topic_slug do
    get ":subtopic_slug", on: :member, to: "subtopics#show"
  end

  # Routes for local restrictions postcode lookup
  get "/find-coronavirus-local-restrictions" => "coronavirus_local_restrictions#show"
  post "/find-coronavirus-local-restrictions" => "coronavirus_local_restrictions#results"

  # TODO: this redirect causes the request to be routed to Whitehall where
  # the country A-Z currently lives. This needs to be removed when the world index
  # page is rendered here
  get "/world/all", to: redirect("/world")

  get "/topic/:topic_slug/:subtopic_slug/latest",
      to: "latest_changes#index",
      as: :latest_changes

  get "/government/feed" => "feeds#all", defaults: { format: "atom" }

  get "/government/organisations",
      to: "organisations#index",
      as: :organisations
  get "/government/organisations/:organisation_name(.:locale).:format",
      constraints: {
        format: /atom/,
        locale: /\w{2}(-[\d\w]{2,3})?/,
      },
      to: "feeds#organisation",
      as: :feed_organisation
  get "/government/organisations/:organisation_name(.:locale)",
      to: "organisations#show",
      as: :organisation
  get "/government/organisations/:organisation_id/services-information",
      to: "services_and_information#index",
      as: :services_and_information

  get "/government/people/:name(.:locale)", to: "people#show"
  get "/government/ministers(.:locale)", to: "ministers#index"
  get "/government/ministers/:name(.:locale)", to: "roles#show"

  scope :api, defaults: { format: :json } do
    get "/organisations",
        to: "organisations_api#index",
        as: :api_organisations
    get "/organisations/:organisation_name",
        to: "organisations_api#show",
        as: :api_organisation

    get "/organisations/*other_route", to: proc { [404, {}, ["404 error"]] }
  end

  get "/courts-tribunals/:organisation_name(.:locale)",
      to: "organisations#court",
      as: :court

  constraints DocumentTypeRoutingConstraint.new("step_by_step_nav") do
    get "/:slug", to: "step_nav#show"
  end

  get "/world/*taxon_base_path", to: "world_wide_taxons#show"
  get "/transition(.:locale)", to: "transition_landing_page#show"

  # We get requests for URLs like
  # https://www.gov.uk/topic%2Flegal-aid-for-providers%2Fmake-application%2Flatest
  # which fall through to here and error in the taxons controller.
  # We can fix the path and redirect to the correct place.
  get "/:slug",
      to: redirect { |_path_params, req|
        [req.path.gsub("%2F", "/"), req.query_string].join("?").chomp("?")
      },
      constraints: ->(req) { req.path.include? "%2F" }

  get "*taxon_base_path", to: "taxons#show"
end

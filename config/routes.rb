Rails.application.routes.draw do
  # Note that this app only receives requests for routes registered with the
  # content-store (by collections-publisher) - whenever the routes below
  # change, also change the routes claimed by collections-publisher.

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  mount GovukPublishingComponents::Engine, at: "/component-guide"

  get "/browse.json" => redirect("/api/content/browse")

  resources :browse, only: %i(index show), param: :top_level_slug do
    get ':second_level_slug', on: :member, to: "second_level_browse_page#show"
  end

  resources :topics, only: %i(index show), path: :topic, param: :topic_slug do
    get ":subtopic_slug", on: :member, to: "subtopics#show"
  end

  #TODO this redirect causes the request to be routed to Whitehall where
  #the country A-Z currently lives. This needs to be removed when the world index
  #page is rendered here
  get '/world/all', to: redirect('/world')

  get "/topic/:topic_slug/:subtopic_slug/latest",
    to: "latest_changes#index", as: :latest_changes

  get "/topic/:topic_slug/:subtopic_slug/email-signup",
    to: "email_signups#new", as: :email_signup
  post "/topic/:topic_slug/:subtopic_slug/email-signup",
    to: "email_signups#create"

  get "/government/feed" => "feeds#all", defaults: { format: "atom" }

  get "/government/organisations",
    to: "organisations#index",
    as: :organisations
  get '/government/organisations/:organisation_name(.:locale).:format',
    constraints: {
      format: /atom/,
      locale: /\w{2}(-[\d\w]{2,3})?/,
    }, to: "feeds#organisation",
    as: :feed_organisation
  get "/government/organisations/:organisation_name(.:locale)",
    to: "organisations#show",
    as: :organisation
  get "/government/organisations/:organisation_id/services-information",
    to: "services_and_information#index",
    as: :services_and_information

  get "/prepare-eu-exit-live-uk",
    to: "brexit_campaign#show"

  get "/government/people/:name", to: "people#show"
  get "/government/ministers/:role_name", to: "roles#show"

  scope :api, defaults: { format: :json } do
    get "/organisations",
      to: "organisations_api#index",
      as: :api_organisations
    get "/organisations/:organisation_name",
      to: "organisations_api#show",
      as: :api_organisation
  end

  constraints DocumentTypeRoutingConstraint.new('step_by_step_nav') do
    get "/:slug", to: 'step_nav#show'
  end

  get '/world/*taxon_base_path', to: 'world_wide_taxons#show'
  get '*taxon_base_path', to: 'taxons#show'
end

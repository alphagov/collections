Rails.application.routes.draw do
  # Note that this app only receives requests for routes registered with the
  # content-store (by collections-publisher) - whenever the routes below
  # change, also change the routes claimed by collections-publisher.

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  mount GovukPublishingComponents::Engine, at: "/component-guide" if defined?(GovukPublishingComponents)

  get "/browse.json" => redirect("/api/content/browse")

  resources :browse, only: [:index, :show], param: :top_level_slug do
    get ':second_level_slug', on: :member, to: "second_level_browse_page#show"
  end

  resources :topics, only: [:index, :show], path: :topic, param: :topic_slug do
    get ":subtopic_slug", on: :member, to: "subtopics#show"
  end

  #TODO this redirect causes the request to be routed to Whitehall where
  #the country A-Z currently lives. This needs to be removed when the world index
  #page is rendered here
  get '/world/all', to: redirect('/world')

  get "/topic/:topic_slug/:subtopic_slug/latest",
    to: "latest_changes#index", as: :latest_changes

  get "/government/organisations/:organisation_id/services-information",
    to: "services_and_information#index",
    as: :services_and_information

  get '*taxon_base_path', to: 'taxons#show'
end

Collections::Application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  get "/browse.json" => redirect("/api/tags.json?type=section&root_sections=true")
  get "/browse" => "browse#index", to: "browse#index"
  get "/browse/:top_level_slug", to: "browse#top_level_browse_page"
  get "/browse/:top_level_slug/:second_level_slug", to: "browse#second_level_browse_page"

  # Make the topics temporarily available under both /topic and their old route.
  # When all Topics have been updated to use the namespace in the content-store,
  # we can remove the duplication.
  get "/topic/:topic_slug/:subtopic_slug/latest", to: "subtopics#latest_changes"
  get "/topic/:topic_slug/:subtopic_slug", to: "subtopics#show"
  get "/topic/:topic_slug", to: "topics#show"
  get "/topic/:topic_slug/:subtopic_slug/email-signup", to: "email_signups#new"
  post "/topic/:topic_slug/:subtopic_slug/email-signup", to: "email_signups#create"

  # Note that this app only receives requests for routes registered with the
  # content-store (by collections-publisher) - whenever the routes below
  # change, also change the routes claimed by collections-publisher.

  get "/:topic_slug/:subtopic_slug/latest", as: "latest_changes", to: "subtopics#latest_changes"
  get "/:topic_slug/:subtopic_slug", as: :subtopic, to: "subtopics#show"
  get "/:topic_slug", to: "topics#show", as: :topic

  get "/:topic_slug/:subtopic_slug/email-signup", to: "email_signups#new", as: "email_signup"
  post "/:topic_slug/:subtopic_slug/email-signup", to: "email_signups#create"
end

Collections::Application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  # Note that this app only receives requests for routes registered with the
  # content-store (by collections-publisher) - whenever the routes below
  # change, also change the routes claimed by collections-publisher.

  get "/browse.json" => redirect("/api/content/browse")
  get "/browse" => "browse#index", to: "browse#index"
  get "/browse/:top_level_slug", to: "browse#top_level_browse_page"
  get "/browse/:top_level_slug/:second_level_slug", to: "browse#second_level_browse_page"

  get "/topic/:topic_slug/:subtopic_slug/latest", to: "subtopics#latest_changes", as: :latest_changes
  get "/topic/:topic_slug/:subtopic_slug", to: "subtopics#show", as: :subtopic
  get "/topic/:topic_slug", to: "topics#show", as: :topic
  get "/topic/:topic_slug/:subtopic_slug/email-signup", to: "email_signups#new", as: :email_signup
  post "/topic/:topic_slug/:subtopic_slug/email-signup", to: "email_signups#create"
end

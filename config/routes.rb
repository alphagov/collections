Collections::Application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  get "/browse.json" => redirect("/api/tags.json?type=section&root_sections=true")
  get "/browse" => "browse#index", to: "browse#index"
  get "/browse/:section", as: "section", to: "browse#section"
  get "/browse/:section/:sub_section", as: "sub_section", to: "browse#sub_section"

  get "/:topic_slug/:subtopic_slug/latest", as: "latest_changes", to: "subtopics#latest_changes"
  get "/:topic_slug/:subtopic_slug", as: :subtopic, to: "subtopics#show"
  get "/:topic_slug", to: "topics#show", as: :topic

  get "/:topic_slug/:subtopic_slug/email-signup", to: "email_signups#new", as: "email_signup"
  post "/:topic_slug/:subtopic_slug/email-signup", to: "email_signups#create"
end

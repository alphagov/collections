Collections::Application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  get "/browse.json" => redirect("/api/tags.json?type=section&root_sections=true")
  get "/browse" => "browse#index", to: "browse#index"
  get "/browse/:section.json" => redirect("/api/tags.json?type=section&parent_id=%{section}")
  get "/browse/:section", as: "section", to: "browse#section"
  get "/browse/:section/:sub_section.json" => redirect("/api/with_tag.json?tag=%{section}%%2F%{sub_section}")
  get "/browse/:section/:sub_section", as: "sub_section", to: "browse#sub_section"

  get "/:topic_slug/:subcategory/latest", as: "latest_changes", to: "subtopics#latest_changes"
  get "/:topic_slug/:subcategory", as: :subtopic, to: "subtopics#show"
  get "/:topic_slug", to: "topics#show"

  get "/:topic_slug/:subcategory/email-signup", to: "email_signups#new", as: "email_signup"
  post "/:topic_slug/:subcategory/email-signup", to: "email_signups#create"
end

Collections::Application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  get "/browse.json" => redirect("/api/tags.json?type=section&root_sections=true")
  get "/browse" => "browse#index", to: "browse#index"
  get "/browse/:section.json" => redirect("/api/tags.json?type=section&parent_id=%{section}")
  get "/browse/:section", as: "section", to: "browse#section"
  get "/browse/:section/:sub_section.json" => redirect("/api/with_tag.json?tag=%{section}%%2F%{sub_section}")
  get "/browse/:section/:sub_section", as: "sub_section", to: "browse#sub_section"

  get "/:sector/:subcategory/latest", as: "latest_changes", to: "subcategories#latest_changes"
  get "/:sector/:subcategory", to: "subcategories#show"
  get "/:sector", to: "specialist_sectors#show"

  resources :email_signups, path: "/:subtopic/email-signups", only: [:create], subtopic: %r{[^/]+/[^/]+}
  get "/:subtopic/email-signup", as: "email_signup", to: "email_signups#new", subtopic: %r{[^/]+/[^/]+}
end

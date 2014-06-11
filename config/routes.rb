Collections::Application.routes.draw do

  get "/browse.json" => redirect("/api/tags.json?type=section&root_sections=true")
  get "/browse" => "browse#index", to: "browse#index"
  get "/browse/:section.json" => redirect("/api/tags.json?type=section&parent_id=%{section}")
  get "/browse/:section", as: "section", to: "browse#section"
  get "/browse/:section/:sub_section.json" => redirect("/api/with_tag.json?tag=%{section}%%2F%{sub_section}")
  get "/browse/:section/:sub_section", as: "sub_section", to: "browse#sub_section"

  get "/:sector", to: "specialist_sectors#sector"
  get "/:sector/:subcategory", to: "specialist_sectors#subcategory"

end

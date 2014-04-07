Collections::Application.routes.draw do

  get "/:sector", to: "specialist_sectors#sector"
  get "/:sector/:subcategory", to: "specialist_sectors#subcategory"

end

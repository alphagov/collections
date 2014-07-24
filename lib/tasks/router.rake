namespace :router do
  task :router_environment => :environment do
    require 'plek'
    require 'gds_api/router'

    @router_api = GdsApi::Router.new(Plek.current.find('router-api'))
  end

  task :register => :register_backend

  task :register_backend => :router_environment do
    @router_api.add_backend('collections', Plek.current.find('collections', :force_http => true) + "/")
  end

  task :register_browse => :router_environment do
    routes = [
      %w(/browse prefix),
      %w(/browse.json exact),
    ]

    routes.each do |path, type|
      @router_api.add_route(path, type, 'collections')
    end
    @router_api.commit_routes
  end
end

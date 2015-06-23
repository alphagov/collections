namespace :router do
  task :router_environment => :environment do
    require 'plek'
    require 'gds_api/router'

    @router_api = GdsApi::Router.new(Plek.current.find('router-api'))
  end

  task :register_browse_redirects => :router_environment do
    routes = [
      %w(/visas-immigration /browse/visas-immigration),
      %w(/business /browse/business),
    ]

    routes.each do |path, destination|
      @router_api.add_redirect_route(path, 'exact', destination)
    end
    @router_api.commit_routes
  end

  task :unregister_browse_redirects => :router_environment do
    routes = [
      %w(/browse/business exact),
      %w(/browse/visas-immigration exact),
    ]

    routes.each do |path, type|
      begin
        @router_api.delete_route(path, type)
      rescue GdsApi::HTTPNotFound
        # the router api returns a 404 if the route doesn't already exist
      end
    end
    @router_api.commit_routes
  end
end

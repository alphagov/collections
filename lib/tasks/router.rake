namespace :router do
  task :router_environment => :environment do
    require 'plek'
    require 'gds_api/router'

    @router_api = GdsApi::Router.new(Plek.current.find('router-api'))
  end

  task :register => :router_environment do
    @router_api.add_backend('collections', Plek.current.find('collections', :force_http => true) + "/")
  end
end

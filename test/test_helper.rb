ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "mocha/setup"

require 'webmock/minitest'
WebMock.disable_net_connect!

Dir[Rails.root.join('test/support/*.rb')].each { |f| require f }

require 'gds_api/test_helpers/content_api'
require 'gds_api/test_helpers/rummager'

class ActiveSupport::TestCase
  include GdsApi::TestHelpers::ContentApi
  include GdsApi::TestHelpers::Rummager

  after do
    WebMock.reset!
  end
end

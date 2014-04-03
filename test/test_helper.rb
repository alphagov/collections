ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "mocha/setup"

Dir[Rails.root.join('test/support/*.rb')].each { |f| require f }

class ActiveSupport::TestCase
  
end

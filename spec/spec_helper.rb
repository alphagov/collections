ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"

# The helpers in the test/support directory are used by minitest specs that are not yet
# converted to RSpec. We should require those helpers rather than duplicate them in
# spec/support so that the files don't diverge. Once all the specs using a helper are
# converted to rspec, we can move the helper file over to spec/support.
Dir[Rails.root.join("test/support/**/*.rb")].sort.each { |f| require f }
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.use_active_record = false
  config.infer_spec_type_from_file_location!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

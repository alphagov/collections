class ActiveSupport::TestCase

  # If we override a service with a mock during testing, we should ensure that
  # we reset it at the end.
  #
  # These before and after blocks will save a reference to specific services
  # before tests are run, and reinstate them after each test has been completed.
  #

  before do
    @existing_services = {}
    @existing_services[:collections_api] = Collections.services(:collections_api)
  end

  after do
    Collections.services(:collections_api, @existing_services[:collections_api])
  end
end

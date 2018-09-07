module GdsApi
  module TestHelpers
    module Rummager
      def rummager_has_services_and_info_data_with_missing_keys_for_organisation
        stub_request_for(search_results_found_with_missing_keys)
        run_example_query
      end

      def search_results_found_with_missing_keys
        File.read(
          File.expand_path(
            '../fixtures/services_and_information_missing_keys_fixture.json',
            __dir__
          )
        )
      end
    end
  end
end

require_relative "../local_restrictions_callout.rb"

namespace :publishing_api do
  desc "Turn on flag whilst the postcode checker is being updated"
  task postcode_checker_updating: :environment do
    local_restrictions_callout = LocalRestrictionCallout.new(updating: true)
    local_restrictions_callout.publish_updating_local_restictions
  end

  desc "Turn off flag once the postcode checker has been updated"
  task postcode_checker_no_longer_updating: :environment do
    local_restrictions_callout = LocalRestrictionCallout.new
    local_restrictions_callout.publish_updating_local_restictions
  end
end

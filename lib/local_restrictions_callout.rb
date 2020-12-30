class LocalRestrictionCallout
  attr_reader :updating
  def initialize(updating: false)
    @updating = updating
  end

  def publish_updating_local_restrictions
    Services.publishing_api.put_content(payload[:content_id], payload[:details])
    Services.publishing_api.publish(payload[:content_id], nil, locale: "en")
  end

private

  BASE_PATH = "/find-coronavirus-local-restrictions".freeze
  CONTENT_ID = "37a1eea3-e3b9-4bc3-8173-bc8afde9dd2d".freeze

  def payload
    {
      content_id: CONTENT_ID,
      details: { "out_of_date" => @updating },
      public_updated_at: Time.zone.now.iso8601,
      update_type: "minor",
    }
  end
end

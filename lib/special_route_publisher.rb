require 'gds_api/publishing_api/special_route_publisher'

class SpecialRoutePublisher
  def initialize(publisher_options)
    @publisher = GdsApi::PublishingApi::SpecialRoutePublisher.new(publisher_options)
  end

  def publish(route_type, route)
    @publisher.publish(
      route.merge(
        format: "special_route",
        publishing_app: "collections-publisher",
        rendering_app: "collections",
        type: route_type,
        public_updated_at: Time.zone.now.iso8601,
        update_type: "major",
      )
    )
  end

  def self.routes
    {
      prefix: [
        {
          content_id: "ecb55f9d-0823-43bd-a116-dbfab2b76ef9",
          base_path: "/brexit-citizens-in-the-uk",
          title: "EU Exit guidance for yourself",
          description: "The content featured on this page has been updated due to Brexit.",
        },
      ]
    }
  end
end
